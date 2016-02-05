library dslink.zabbix.nodes.zabbix_host;

import 'dart:async';
import 'dart:collection';

import 'package:dslink/utils.dart' show logger;

import 'client.dart';
import 'common.dart';

class ZabbixHost extends ZabbixChild {
  static final String isType = 'zabbixHostNode';
  static const availTypes = const ['Unknown', 'Available', 'Unavailable'];
  static const ipmiAuthTypes = const ['default', 'none', 'MD2', 'MD5', '',
    'straight', 'OEM', 'RMCP+'];
  static const ipmiPrivs = const ['callback', 'user', 'operator', 'admin', 'OEM'];
  static const statuses = const ['Monitored', 'Unmonitored'];

  static Map<String, dynamic> definition(Map host) {
    var available = availTypes[int.parse(host['available'])];
    var ipmiAvailable = availTypes[int.parse(host['ipmi_available'])];
    var jmxAvailable = availTypes[int.parse(host['jmx_available'])];
    var snmpAvailable = availTypes[int.parse(host['snmp_available'])];

    var ipmiAuth = ipmiAuthTypes[int.parse(host['ipmi_authtype']) + 1];
    var ipmiPriv = ipmiPrivs[int.parse(host['ipmi_privilege']) - 1];

    var authTypeEnum = ipmiAuthTypes.where((String el) => el.isNotEmpty).join(',');

    return {
      r'$is' : isType,
      r'$name' : host['host'],
      'hostId' : ZabbixValue.definition('Host ID', 'string', host['hostid'], false),
      'available' : ZabbixValue.definition('Available', 'string', available, false),
      'description' : ZabbixValue.definition('Description', 'string',
                        host['description'], true),
      'disable_until' : ZabbixValue.definition('Disable until', 'string',
                        host['disable_until'], false),
      'error' : ZabbixValue.definition('Error', 'string', host['error'], false),
      'error_from' : ZabbixValue.definition('Error From', 'string',
                        host['error_from'], false),
      'flags' : ZabbixValue.definition('Flags', 'string',
                (host['flags'] == 0 ? 'Plain host' : 'Discovered host'), false),
      'IPMI' : {
        r'$type' : 'string',
        r'?value' : ipmiAvailable,
        'ipmi_authtype' : ZabbixValue.definition('IPMI Authentication',
            'enum[$authTypeEnum]', ipmiAuth, true),
        'ipmi_available' : ZabbixValue.definition('IPMI Agent Available', 'string',
            ipmiAvailable, false),
        'ipmi_disable_until' : ZabbixValue.definition('IPMI Disable Until', 'string',
            host['ipmi_disable_until'], false),
        'ipmi_error' : ZabbixValue.definition('IPMI Error', 'string',
            host['ipmi_error'], false),
        'ipmi_password' : ZabbixValue.definition('IPMI Password', 'string',
            host['ipmi_password'], true),
        'ipmi_privlege' : ZabbixValue.definition('IPMI Privlege Level',
            'enum[callback,user,operator,admin,OEM]',
            ipmiPriv, true),
        'ipmi_username' : ZabbixValue.definition('IPMI Username', 'string',
            host['ipmi_username'], true)
      },
      'JMX' : {
        r'$type' : 'string',
        r'?value' : jmxAvailable,
        'jmx_available' : ZabbixValue.definition('JMX Available', 'string',
            jmxAvailable, false),
        'jmx_disable_until' : ZabbixValue.definition('JMX Disable Until', 'string',
            host['jmx_disable_until'], false),
        'jmx_error' : ZabbixValue.definition('JMX Error', 'string',
            host['jmx_error'], false),
        'jmx_error_from' : ZabbixValue.definition('JMX Error From', 'string',
            host['jxm_error_from'], false),
      },
      'maintenanceid' : {
        r'$name' : 'Maintenance ID',
        r'$type' : 'string',
        r'?value' : host['maintenanceid'],
        'maintenance_from' : ZabbixValue.definition('Maintenance From', 'string',
            host['maintenance_from'], false),
        'maintenance_status' : ZabbixValue.definition('Maintenance Status', 'string',
            (host['maintenance_status'] == 0 ? 'no maintenance' : 'in effect'),
            false),
        'maintenance_type' : ZabbixValue.definition('Maintenance Type', 'string',
            (host['maintenance_status'] == 0 ?
            'with data collection' : 'without data collection'), false),
      },
      'name' : ZabbixValue.definition('name', 'string', host['name'], true),
      'proxy_hostid' : ZabbixValue.definition('Proxy Host ID', 'string',
            host['proxy_hostid'], true),
      'SNMP' : {
        r'$type' : 'string',
        r'?value' : snmpAvailable,
        'snmp_available' : ZabbixValue.definition('SNMP Available', 'string',
            snmpAvailable, false),
        'snmp_disable_until' : ZabbixValue.definition('SNMP Disable Until',
            'string', host['snmp_disable_until'], false),
        'snmp_error' : ZabbixValue.definition('SNMP Error', 'string',
            host['snmp_error'], false),
        'snmp_errors_from' : ZabbixValue.definition('SNMP Errors From', 'string',
            host['snmp_errors_from'], false)
      },
      'status' : ZabbixValue.definition('Status', 'enum[${statuses.join(',')}]',
          statuses[int.parse(host['status'])], true)
    };
  }

  static HashMap<String, ZabbixHost> _cache = new HashMap<String, ZabbixHost>();
  static ZabbixHost getById(String hostId) => _cache[hostId];

  ZabbixHost(String path) : super(path);

  @override
  void onCreated() {
    var hostId = provider.getNode('$path/hostId').value;
    _cache.putIfAbsent(hostId, () => this);
  }

  //TODO
  bool updateChild(String path, String valueName, newValue, oldValue) {
    var hostid = name;
    var sendVal;

    switch (valueName) {
      case 'ipmi_authtype':
        sendVal = ipmiAuthTypes.indexOf(newValue) - 1;
        break;
      case 'ipmi_privlege':
        sendVal = ipmiPrivs.indexOf(newValue) + 1;
        break;
      case 'status':
        sendVal = statuses.indexOf(newValue);
        break;
      default:
        sendVal = newValue;
        break;
    }

    var params = {
      'hostid' : hostid,
      valueName : sendVal
    };

    _updateValue(path, params, oldValue);
    return false;
  }

  Future _updateValue(String path, Map params, oldValue) async {
    var cl = await client;
    var res = await cl.makeRequest(RequestMethod.hostUpdate, params);
    if (res.containsKey('error')) {
      logger.warning('Error updating: "$params" Server error: ${res['error']}');
      provider.updateValue(path, oldValue);
    }
  }
}
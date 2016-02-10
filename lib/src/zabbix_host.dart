library dslink.zabbix.nodes.zabbix_host;

import 'dart:async';
import 'dart:collection';

import 'package:dslink/dslink.dart' show LocalNode;
import 'package:dslink/utils.dart' show logger;

import 'client.dart';
import 'common.dart';

class ZabbixHost extends ZabbixChild {
  static const String isType = 'zabbixHostNode';
  static const _availTypes = const ['Unknown', 'Available', 'Unavailable'];
  static const _ipmiAuthTypes = const ['default', 'none', 'MD2', 'MD5', '',
    'straight', 'OEM', 'RMCP+'];
  static const _ipmiPrivs = const ['callback', 'user', 'operator', 'admin', 'OEM'];
  static const _statuses = const ['Monitored', 'Unmonitored'];
  static const _flags = const { '0' : 'Plain host', '4' : 'Discovered host' };
  static const _maintenanceStatuses = const {
    '0' : 'No Maintenance',
    '1' : 'In effect'
  };
  static const _maintenanceTypes = const {
    '0' : 'With data collection',
    '1' : 'Without data collection'
  };

  static Map<String, dynamic> definition(Map host) {
    var available = _availTypes[int.parse(host['available'])];
    var ipmiAvailable = _availTypes[int.parse(host['ipmi_available'])];
    var jmxAvailable = _availTypes[int.parse(host['jmx_available'])];
    var snmpAvailable = _availTypes[int.parse(host['snmp_available'])];

    var ipmiAuth = _ipmiAuthTypes[int.parse(host['ipmi_authtype']) + 1];
    var ipmiPriv = _ipmiPrivs[int.parse(host['ipmi_privilege']) - 1];
    var status = _statuses[int.parse(host['status'])];
    var flag = _flags[host['flags']];

    var authTypeEnum = _ipmiAuthTypes.where((String el) => el.isNotEmpty).join(',');

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
      'flags' : ZabbixValue.definition('Flags', 'string', flag, false),
      'IPMI' : {
        r'$type' : 'string',
        r'?value' : ipmiAvailable,
        'ipmi_authtype' : ZabbixValue.definition('IPMI Authentication',
            'enum[$authTypeEnum]', ipmiAuth, true),
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
            _maintenanceStatuses[host['maintenance_status']], false),
        'maintenance_type' : ZabbixValue.definition('Maintenance Type', 'string',
            _maintenanceTypes[host['maintenance_type']], false),
      },
      'name' : ZabbixValue.definition('name', 'string', host['name'], true),
      'proxy_hostid' : ZabbixValue.definition('Proxy Host ID', 'string',
            host['proxy_hostid'], true),
      'SNMP' : {
        r'$type' : 'string',
        r'?value' : snmpAvailable,
        'snmp_disable_until' : ZabbixValue.definition('SNMP Disable Until',
            'string', host['snmp_disable_until'], false),
        'snmp_error' : ZabbixValue.definition('SNMP Error', 'string',
            host['snmp_error'], false),
        'snmp_errors_from' : ZabbixValue.definition('SNMP Errors From', 'string',
            host['snmp_errors_from'], false)
      },
      'status' : ZabbixValue.definition('Status', 'enum[${_statuses.join(',')}]',
          status, true)
    };
  }

  static HashMap<String, ZabbixHost> _cache = new HashMap<String, ZabbixHost>();
  static ZabbixHost getById(String hostId) => _cache[hostId];
  static List<String> getAllIds() => _cache.keys.toList(growable: false);

  ZabbixHost(String path) : super(path);

  @override
  void onCreated() {
    var hostId = name;
    _cache.putIfAbsent(hostId, () => this);
  }

  bool updateChild(String path, String valueName, newValue, oldValue) {
    var hostid = name;
    var sendVal;

    switch (valueName) {
      case 'ipmi_authtype':
        sendVal = _ipmiAuthTypes.indexOf(newValue) - 1;
        break;
      case 'ipmi_privlege':
        sendVal = _ipmiPrivs.indexOf(newValue) + 1;
        break;
      case 'status':
        sendVal = _statuses.indexOf(newValue);
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

  void update(Map updatedValues) {
    var available = _availTypes[int.parse(updatedValues['available'])];
    var ipmiAvailable = _availTypes[int.parse(updatedValues['ipmi_available'])];
    var jmxAvailable = _availTypes[int.parse(updatedValues['jmx_available'])];
    var snmpAvailable = _availTypes[int.parse(updatedValues['snmp_available'])];
    var ipmiAuth = _ipmiAuthTypes[int.parse(updatedValues['ipmi_authtype']) + 1];
    var ipmiPriv = _ipmiPrivs[int.parse(updatedValues['ipmi_privilege']) - 1];
    var status = _statuses[int.parse(updatedValues['status'])];
    var flag = _flags[updatedValues['flags']];
    var maintStatus = _maintenanceStatuses[updatedValues['maintenance_status']];
    var maintType = _maintenanceTypes[updatedValues['maintenance_type']];

    for (var key in updatedValues.keys) {
      LocalNode nd = provider.getNode('$path/$key');
      var newVal;

      if (key.startsWith('ipmi')) {
        if (key == 'ipmi_available') {
          nd = provider.getNode('$path/IPMI');
        } else {
          nd = provider.getNode('$path/IPMI/$key');
        }
      } else if (key.startsWith('jmx')) {
        if (key == 'jmx_available') {
          nd = provider.getNode('$path/JMX');
        } else {
          nd = provider.getNode('$path/JMX/$key');
        }
      } else if (key.startsWith('snmp')) {
        if (key == 'snmp_available') {
          nd = provider.getNode('$path/SNMP');
        } else {
          nd = provider.getNode('$path/SNMP/$key');
        }
      } else if (key.startsWith('maintenance_')) {
        nd = provider.getNode('$path/maintenanceid/$key');
      }

      switch (key) {
        case 'available':
          newVal = available;
          break;
        case 'flags':
          newVal = flag;
          break;
        case 'ipmi_available':
          newVal = ipmiAvailable;
          break;
        case 'ipmi_authtype':
          newVal = ipmiAuth;
          break;
        case 'ipmi_privlege':
          newVal = ipmiPriv;
          break;
        case 'jmx_available':
          newVal = jmxAvailable;
          break;
        case 'maintenance_status':
          newVal = maintStatus;
          break;
        case 'maintenance_type':
          newVal = maintType;
          break;
        case 'snmp_available':
          newVal = snmpAvailable;
          break;
        case 'status':
          newVal = status;
          break;
        default:
          newVal = updatedValues[key];
      }

      nd?.updateValue(newVal);
    }

  }
}
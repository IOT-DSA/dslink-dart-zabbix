library dslink.zabbix.nodes.zabbix_host;

import 'dart:async';
import 'dart:collection';

import 'package:dslink/dslink.dart' show LocalNode;
import 'package:dslink/utils.dart' show logger;

import 'client.dart';
import 'common.dart';

//* @Node
//* @MetaType ZabbixHost
//* @Is zabbixHostNode
//* @Parent ZabbixHostGroup
//*
//* A host in the Zabbix Server.
//*
//* ZabbixHost represents a host as defined on the remote server. It's path
//* is the hostId and display name is the host name.
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
      //* @Node hostId
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Id of the host.
      //*
      //* @Value string
      'hostId' : ZabbixValue.definition('Host ID', 'string', host['hostid'], false),
      //* @Node available
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Availability of Zabbix agent on host.
      //*
      //* String representation of the availability of the Zabbix Agent on the
      //* host. Values may be Available, Unavailable, or Unknown. Value may not
      //* be set.
      //*
      //* @Value string
      'available' : ZabbixValue.definition('Available', 'string', available, false),
      //* @Node description
      //* @MetaType hDescription
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Description of host. May be set.
      //*
      //* @Value string
      'description' : ZabbixValue.definition('Description', 'string',
                        host['description'], true),
      //* @Node disable_until
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Timestamp for the next polling time of an unavailable Zabbix agent.
      //*
      //* @Value string
      'disable_until' : ZabbixValue.definition('Disable until', 'string',
                        host['disable_until'], false),
      //* @Node error
      //* @MetaType hError
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Error text if Zabbix agent on host is unavailable.
      //*
      //* @Value string
      'error' : ZabbixValue.definition('Error', 'string', host['error'], false),
      //* @Node error_from
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Timestamp when the Zabbix agent on host became unavailable.
      //*
      //* @Value string
      'error_from' : ZabbixValue.definition('Error From', 'string',
                        host['error_from'], false),
      //* @Node flags
      //* @MetaType hFlags
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Origin of the host.
      //*
      //* A string representation of the origin of the host.
      //* Value may be Plain Host or Discovered Host. Value cannot be set.
      //*
      //* @Value string
      'flags' : ZabbixValue.definition('Flags', 'string', flag, false),
      //* @Node IPMI
      //* @Parent ZabbixHost
      //*
      //* IPMI availability and grouping of other IPMI related values.
      //*
      //* IPMI value is a string representation of the availability of the agent.
      //* Value may be Available, Unavailable, or Unknown.
      //*
      //* @Value string
      'IPMI' : {
        r'$type' : 'string',
        r'?value' : ipmiAvailable,
        //* @Node ipmi_authtype
        //* @Is zabbixValueNode
        //* @Parent IPMI
        //*
        //* IPMI authentication algorithm.
        //*
        //* String representation of the authentication algorithm used by the
        //* IPMI agent. Value may be set to one of the valid enum values.
        //*
        //* @Value enum[default,none,MD2,MD5,straight,OEM,RMCP+]
        'ipmi_authtype' : ZabbixValue.definition('IPMI Authentication',
            'enum[$authTypeEnum]', ipmiAuth, true),
        //* @Node ipmi_disable_until
        //* @Is zabbixValueNode
        //* @Parent IPMI
        //*
        //* Timestamp for the next polling time of an unavailable IPMI agent.
        //*
        //* @Value string
        'ipmi_disable_until' : ZabbixValue.definition('IPMI Disable Until', 'string',
            host['ipmi_disable_until'], false),
        //* @Node ipmi_error
        //* @Is zabbixValueNode
        //* @Parent IPMI
        //*
        //* Error text if IPMI agent is unavailable.
        //*
        //* @Value string
        'ipmi_error' : ZabbixValue.definition('IPMI Error', 'string',
            host['ipmi_error'], false),
        //* @Node ipmi_password
        //* @Is zabbixValueNode
        //* @Parent IPMI
        //*
        //* Password required to authenticate with the IPMI.
        //*
        //* The IPMI Password is used for the server to authenticate with IPMI.
        //* This value may be set to update it on the remote server.
        //*
        //* @Value string
        'ipmi_password' : ZabbixValue.definition('IPMI Password', 'string',
            host['ipmi_password'], true),
        //* @Node ipmi_privlege
        //* @Is zabbixValueNode
        //* @Parent IPMI
        //*
        //* IPMI Privilege level
        //*
        //* This is the string representation of IPMI priviledge level on the
        //* server. This value may be modified with one of the enum values.
        //*
        //* @Value enum[callback,user,operator,admin,OEM]
        'ipmi_privlege' : ZabbixValue.definition('IPMI Privlege Level',
            'enum[callback,user,operator,admin,OEM]',
            ipmiPriv, true),
        //* @Node ipmi_username
        //* @Is zabbixValueNode
        //* @Parent IPMI
        //*
        //* Username required to authenticate with the IPMI
        //*
        //* The IPMI Username is used for the server to authenticate with IPMI.
        //* This value may be set to update it on the remote server.
        //*
        //* @Value string
        'ipmi_username' : ZabbixValue.definition('IPMI Username', 'string',
            host['ipmi_username'], true)
      },
      //* @Node JMX
      //* @Parent ZabbixHost
      //*
      //* JMX Availability and grouping of other JMX related values.
      //*
      //* JMX value is a string representation of the availability of JMX agent.
      //* Value may be Available, Unavailable, or Unknown.
      //*
      //* @Value string
      'JMX' : {
        r'$type' : 'string',
        r'?value' : jmxAvailable,
        //* @Node jmx_disable_until
        //* @Is zabbixValueNode
        //* @Parent JMX
        //*
        //* Timestamp value of the next polling time of an unavailable JMX agent.
        //*
        //* @Value string
        'jmx_disable_until' : ZabbixValue.definition('JMX Disable Until', 'string',
            host['jmx_disable_until'], false),
        //* @Node jmx_error
        //* @Is zabbixValueNode
        //* @Parent JMX
        //*
        //* Error text if the JMX agent is unavailable.
        //*
        //* @Value string
        'jmx_error' : ZabbixValue.definition('JMX Error', 'string',
            host['jmx_error'], false),
        //* @Node jmx_error_from
        //* @Is zabbixValueNode
        //* @Parent JMX
        //*
        //* Timestamp value of when the JMX agent became unavailable.
        //*
        //* @Value string
        'jmx_error_from' : ZabbixValue.definition('JMX Error From', 'string',
            host['jxm_error_from'], false),
      },
      //* @Node maintenanceid
      //* @Parent ZabbixHost
      //*
      //* The ID of the maintenance that is currently in effect on the host.
      //*
      //* @Value string
      'maintenanceid' : {
        r'$name' : 'Maintenance ID',
        r'$type' : 'string',
        r'?value' : host['maintenanceid'],
        //* @Node maintenance_from
        //* @Is zabbixValueNode
        //* @Parent maintenanceid
        //*
        //* Timestamp of the starting time of the effective maintenance.
        //*
        //* @Value string
        'maintenance_from' : ZabbixValue.definition('Maintenance From', 'string',
            host['maintenance_from'], false),
        //* @Node maintenance_status
        //* @Is zabbixValueNode
        //* @Parent maintenanceid
        //*
        //* Effective maintenance status.
        //*
        //* This is a string representation of the current maintenance status.
        //* Value may be No Maintenance or In effect.
        //*
        //* @Value string
        'maintenance_status' : ZabbixValue.definition('Maintenance Status', 'string',
            _maintenanceStatuses[host['maintenance_status']], false),
        //* @Node maintenance_type
        //* @Is zabbixValueNode
        //* @Parent maintenanceid
        //*
        //* Effective maintenance type.
        //*
        //* Maintenance Type is a string representation of the current
        //* maintenance type. Value may be With data collection or Without
        //* data collection.
        //*
        //* @Value string
        'maintenance_type' : ZabbixValue.definition('Maintenance Type', 'string',
            _maintenanceTypes[host['maintenance_type']], false),
      },
      //* @Node name
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Name of the host on the remote server.
      //*
      //* This value may be updated to update host configuration on the remote
      //* server. Successful update will also update the display name of this
      //* ZabbixHost node.
      //*
      //* @Value string
      'name' : ZabbixValue.definition('name', 'string', host['name'], true),
      //* @Node proxy_hostid
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Id of the proxy that is used to monitor the host.
      //*
      //* The value of this field can be updated to change the proxy used for
      //* monitoring this host.
      //*
      //* @Value string
      'proxy_hostid' : ZabbixValue.definition('Proxy Host ID', 'string',
            host['proxy_hostid'], true),
      //* @Node SNMP
      //* @Parent ZabbixHost
      //*
      //* Grouping of SNMP related values, and SNMP availability.
      //*
      //* The value of this field indicates if
      //* SNMP functionality for this host is Available, Unavailable or Unknown.
      //*
      //* @Value string
      'SNMP' : {
        r'$type' : 'string',
        r'?value' : snmpAvailable,
        //* @Node snmp_disable_until
        //* @Is zabbixValueNode
        //* @Parent SNMP
        //*
        //* Timestamp of the next polling time of an unavailable SNMP agent.
        //*
        //* @Value string
        'snmp_disable_until' : ZabbixValue.definition('SNMP Disable Until',
            'string', host['snmp_disable_until'], false),
        //* @Node snmp_error
        //* @Is zabbixValueNode
        //* @Parent SNMP
        //*
        //* Error text if SNMP is unavailable.
        //*
        //* @Value string
        'snmp_error' : ZabbixValue.definition('SNMP Error', 'string',
            host['snmp_error'], false),
        //* @Node snmp_errors_from
        //* @Is zabbixValueNode
        //* @Parent SNMP
        //*
        //* Timestamp when the SNMP agent became unavailable.
        //*
        //* @Value string
        'snmp_errors_from' : ZabbixValue.definition('SNMP Errors From', 'string',
            host['snmp_errors_from'], false)
      },
      //* @Node status
      //* @Is zabbixValueNode
      //* @Parent ZabbixHost
      //*
      //* Status of the Host.
      //*
      //* Status may be @set to disable or enable monitoring of this host.
      //*
      //* @Value enum[Monitored,Unmonitored]
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

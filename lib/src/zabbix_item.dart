library dslink.zabbix.nodes.zabbix_item;

import 'dart:async';
import 'dart:collection' show HashMap;

import 'package:dslink/utils.dart' show logger;

import 'common.dart';
import 'client.dart';

class ZabbixItem extends ZabbixChild {
  static const String isType = 'zabbixItemNode';

  static const authTypes = const ['password', 'public key'];
  static const itemTypes = const ['Zabbix Agent', 'SNMPv1 Agent', 'Zabbix Trapper',
      'Simple Check', 'SNMPv2 Agent', 'Zabbix Internal', 'SNMPv3 Agent',
      'Zabbix Agent (active)', 'Zabbix Aggregate', 'Web Item',
      'External Clock', 'Database Monitor', 'IPMI Agent', 'SSH Agent',
      'Telnet Agent', 'Calculated', 'JMX Agent', 'SNMP Trap'];
  static const valueTypes = const ['Numeric float', 'Character', 'Log',
      'Numeric unsigned', 'text'];
  static const dataTypes = const ['decimal', 'octal', 'hexadecimal', 'boolean'];
  static const deltaTypes = const ['as is', 'Delta (speed per second)',
      'Delta (simple change)'];
  static const snmpv3AuthProtocols = const ['MD5', 'SHA'];
  static const snmpv3PrivProtocols = const ['DES', 'AES'];
  static const snmpv3SecurityLevels = const ['noAuthNoPriv', 'authNoPriv', 'authPriv'];
  static const states = const['normal', 'not supported'];
  static const statuses = const ['enabled', 'disabled'];
  static const flags = const { '0': 'Plain Item', '1' : 'Discovered Item' };

  static Map<String, dynamic> definition(Map item) {
    var itmType = itemTypes[int.parse(item['type'])];
    var valType = valueTypes[int.parse(item['value_type'])];
    var dataType = dataTypes[int.parse(item['data_type'])];
    var deltaType = deltaTypes[int.parse(item['delta'])];
    var snmpv3AuthProto = snmpv3AuthProtocols[int.parse(item['snmpv3_authprotocol'])];
    var snmpv3PrivProto = snmpv3PrivProtocols[int.parse(item['snmpv3_privprotocol'])];
    var snmpv3Seclvl = snmpv3SecurityLevels[int.parse(item['snmpv3_securitylevel'])];

    return {
      r'$is' : isType,
      r'$name' : item['key_'],
      'itemid' : ZabbixValue.definition('Item ID', 'string', item['itemid'], false),
      'delay' : ZabbixValue.definition('Delay', 'number', item['delay'], true),
      'hostid' : ZabbixValue.definition('Host ID', 'string', item['hostid'], true),
      'interfaceid' : ZabbixValue.definition('Host Interface ID', 'string',
          item['interfaceid'], true),
      'key' : ZabbixValue.definition('Key', 'string', item['key_'], true),
      'name' : ZabbixValue.definition('Name', 'string', item['name'], true),
      'type' : ZabbixValue.definition('Type', 'enum[${itemTypes.join(',')}]',
          itmType, true),
      'value_type' : ZabbixValue.definition('Value Type',
          'enum[${valueTypes.join(',')}]', valType, true),
      'authtype' : ZabbixValue.definition(
          'SSH Authentication Method', 'enum[${authTypes.join(',')}]',
          authTypes[int.parse(item['authtype'])], true),
      'data_type' : ZabbixValue.definition('Data Type', 'enum[${dataTypes.join(',')}]',
          dataType, true),
      'delay_flex' : ZabbixValue.definition('Delay Flex', 'string', item['data_flex'], true),
      'delta' : ZabbixValue.definition('Delta Type', 'enum[${deltaTypes.join(',')}]',
          deltaType, true),
      'description' : ZabbixValue.definition('Description', 'string',
          item['description'], true),
      'error' : ZabbixValue.definition('Error', 'string', item['error'], false),
      'flags' : ZabbixValue.definition('Flags', 'string',
          flags[item['flag']], false),
      'formula' : ZabbixValue.definition('Custom multiplier', 'number',
          num.parse(item['formula'], (_) => 1), true),
      'history' : ZabbixValue.definition('History age', 'number',
          int.parse(item['history']), true),
      'inventory_link' : ZabbixValue.definition('Host Inventory Id', 'number',
          int.parse(item['inventory_link']), true),
      'ipmi_sensor' : ZabbixValue.definition('IPMI Sensor', 'string',
          item['ipmi_sensor'], true),
      'last_clock' : ZabbixValue.definition('Last updated', 'string',
          item['last_clock'], false),
      'lastns' : ZabbixValue.definition('Last updated nanoseconds', 'number',
          int.parse(item['lastns']), false),
      'lastvalue' : ZabbixValue.definition('Last Value', 'string',
          item['lastvalue'], false),
      'logtimefmt' : ZabbixValue.definition('Log time format', 'string',
          item['logtimefmt'], true),
      'mtime' : ZabbixValue.definition('Monitored Log last updated', 'string',
          item['mtime'], false),
      'multiplier' : ZabbixValue.definition('Use custom multiplier', 'number',
          int.parse(item['multiplier']), true),
      'params' : ZabbixValue.definition('Additional Parameters', 'string',
          item['params'], true),
      'passsword' : ZabbixValue.definition('Password', 'string', item['password'], true),
      'port' : ZabbixValue.definition('Port', 'sting', item['port'], true),
      'prevvalue' : ZabbixValue.definition('Previous Value', 'string',
          item['prevvalue'], false),
      'privatekey' : ZabbixValue.definition('Private Key filename', 'string',
          item['privatekey'], true),
      'publickey' : ZabbixValue.definition('Public Key filename', 'string',
          item['publickey'], true),
      'snmp' : {
        r'$type' : 'string',
        r'?value' : '',
        'snmp_community' : ZabbixValue.definition('SNMP Community', 'string',
            item['snmp_community'], true),
        'snmp_oid' : ZabbixValue.definition('OID', 'string', item['snmp_oid'], true),
        'snmpv3_authpassphrase' : ZabbixValue.definition('SNMPv3 Passphrase', 'string',
            item['snmpv3_authpassphrase'], true),
        'snmpv3_authprotocol' : ZabbixValue.definition('SNMPv3 Protocol',
            'enum[${snmpv3AuthProtocols.join(',')}]', snmpv3AuthProto, true),
        'snmpv3_contextname' : ZabbixValue.definition('SNMPv3 Context Name',
            'string', item['snmpv3_contextname'], true),
        'snmpv3_privpassphrase' : ZabbixValue.definition('SNMPv3 Priv Passphrase',
            'string', item['snmpv3_privpassphrase'], true),
        'snmpv3_privprotocol' : ZabbixValue.definition('SNMPv3 Priv Protocol',
            'enum[${snmpv3AuthProtocols.join(',')}]', snmpv3PrivProto, true),
        'snmpv3_securitylevel' : ZabbixValue.definition('SNMPv3 Security Level',
            'enum[${snmpv3SecurityLevels.join(',')}]', snmpv3Seclvl, true),
        'snmpv3_securityname' : ZabbixValue.definition('Security name', 'string',
            item['snmpv3_securityname'], true)
      },
      'state' : ZabbixValue.definition('State', 'enum[${states.join(',')}]',
          states[int.parse(item['state'])], false),
      'status' : ZabbixValue.definition('Status', 'enum[${statuses.join(',')}]',
          statuses[int.parse(item['status'])], true),
      'templateid' : ZabbixValue.definition('Template Id', 'string',
          item['templateid'], false),
      'trapper_hosts' : ZabbixValue.definition('Trapper allowed hosts', 'string',
          item['trapper_hosts'], true),
      'trends' : ZabbixValue.definition('Days of trends data', 'number',
          int.parse(item['trends']), true),
      'units' : ZabbixValue.definition('Value units', 'string', item['units'], true),
      'username' : ZabbixValue.definition('Authentication username', 'string',
          item['username'], true),
      'valuemapid' : ZabbixValue.definition('Map ID', 'string', item['valuemap'], true)
    };
  }

  static HashMap<String, ZabbixItem> _cache = new HashMap<String, ZabbixItem>();
  static getById(String id) => _cache[id];

  ZabbixItem(String path) : super(path);

  @override
  void onCreated() {
    _cache.putIfAbsent(name, () => this);
  }

  bool updateChild(String path, String valueName, newValue, oldValue) {
    var itemid = name;
    var sendVal;
    switch (valueName) {
      case 'type' :
        sendVal = itemTypes.indexOf(newValue);
        break;
      case 'value_type':
        sendVal = valueTypes.indexOf(newValue);
        break;
      case 'authtype':
        sendVal = authTypes.indexOf(newValue);
        break;
      case 'data_type':
        sendVal = dataTypes.indexOf(newValue);
        break;
      case 'delta':
        sendVal = deltaTypes.indexOf(newValue);
        break;
      case 'snmpv3_authprotocol':
        sendVal = snmpv3AuthProtocols.indexOf(newValue);
        break;
      case 'snmpv3_privprotocol':
        sendVal = snmpv3PrivProtocols.indexOf(newValue);
        break;
      case 'snmpv3_securitylevel':
        sendVal = snmpv3SecurityLevels.indexOf(newValue);
        break;
      case 'status':
        sendVal = statuses.indexOf(newValue);
        break;
      default:
        sendVal = newValue;
        break;
    }

    var params = {
      'itemid' : itemid,
      valueName : sendVal
    };

    _updateValue(path, params, oldValue);

    return false;
  }

  Future _updateValue(String path, Map params, oldValue) async {
    var cl = await client;
    var res = await cl.makeRequest(RequestMethod.itemUpdate, params);
    if (res.containsKey('error')) {
      logger.warning('Error updating: "$params" Server error: ${res['error']}');
      provider.updateValue(path, oldValue);
    }

  }

  void update(Map updatedValues) {
    var flag = flags[updatedValues['flags']];
    var authType = authTypes[int.parse(updatedValues['authtype'])];
    var itmType = itemTypes[int.parse(updatedValues['type'])];
    var valType = valueTypes[int.parse(updatedValues['value_type'])];
    var dataType = dataTypes[int.parse(updatedValues['data_type'])];
    var deltaType = deltaTypes[int.parse(updatedValues['delta'])];
    var state = states[int.parse(updatedValues['state'])];
    var status = statuses[int.parse(updatedValues['status'])];
    var snmpv3AuthProto = snmpv3AuthProtocols[int.parse(updatedValues['snmpv3_authprotocol'])];
    var snmpv3PrivProto = snmpv3PrivProtocols[int.parse(updatedValues['snmpv3_privprotocol'])];
    var snmpv3Seclvl = snmpv3SecurityLevels[int.parse(updatedValues['snmpv3_securitylevel'])];

    for (var key in updatedValues.keys) {
      var newVal;
      ZabbixValue nd;
      if (key.startsWith('snmp')) {
        nd = provider.getNode('$path/snmp/$key');
      } else {
        nd = provider.getNode('$path/$key');
      }

      switch (key) {
        case 'authtype':
          newVal = authType;
          break;
        case 'type' :
          newVal = itmType;
          break;
        case 'value_type':
          newVal = valType;
          break;
        case 'data_type':
          newVal = dataType;
          break;
        case 'delta':
          newVal = deltaType;
          break;
        case 'flags':
          newVal = flag;
          break;
        case 'formula':
          newVal = num.parse(updatedValues['formula']);
          break;
        case 'history':
          newVal = int.parse(updatedValues['history']);
          break;
        case 'inventory_link':
          newVal = int.parse(updatedValues['inventory_link']);
          break;
        case 'lastns':
          newVal = int.parse(updatedValues['lastns']);
          break;
        case 'multiplier':
          newVal = int.parse(updatedValues['multiplier']);
          break;
        case 'snmpv3_authprotocol':
          newVal = snmpv3AuthProto;
          break;
        case 'snmpv3_privprotocol':
          newVal = snmpv3PrivProto;
          break;
        case 'snmpv3_securitylevel':
          newVal = snmpv3Seclvl;
          break;
        case 'state':
          newVal = state;
          break;
        case 'status':
          newVal = status;
          break;
        case 'trends':
          newVal = int.parse(updatedValues['trends']);
          break;
        default:
          newVal = updatedValues[key];
      }

      nd?.updateValue(newVal);
    }
  }
}
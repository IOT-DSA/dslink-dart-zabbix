library dslink.zabbix.nodes.zabbix_item;

import 'dart:async';
import 'dart:collection' show HashMap;

import 'package:dslink/utils.dart' show logger;

import 'common.dart';
import 'client.dart';

//* @Node
//* @MetaType ZabbixItem
//* @Parent Items
//*
//* Items associated with a given Zabbix Host.
//*
//* Detailed information regarding the monitoring points for a given Zabbix Host.
//* The path is the Item Id and the display name is the item's key.
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
    var lastClock = new DateTime.fromMillisecondsSinceEpoch(int.parse(item['lastclock']) * 1000);
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
      //* @Node itemid
      //* @MetaType itemItemid
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Id of the Item.
      //* @Value string
      'itemid' : ZabbixValue.definition('Item ID', 'string', item['itemid'], false),
      //* @Node delay
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Update interval of the item in seconds.
      //* @Value number write
      'delay' : ZabbixValue.definition('Delay', 'number', item['delay'], true),
      //* @Node hostid
      //* @MetaType itemHostid
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Id of the host the item belongs to.
      //* @Value string write
      'hostid' : ZabbixValue.definition('Host ID', 'string', item['hostid'], true),
      //* @Node interfaceid
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Id of the item's host interface. Only for host items.
      //* @Value string write
      'interfaceid' : ZabbixValue.definition('Host Interface ID', 'string',
          item['interfaceid'], true),
      //* @Node key
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Item key
      //* @Value string write
      'key' : ZabbixValue.definition('Key', 'string', item['key_'], true),
      //* @Node name
      //* @MetaType itemName
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Name of the item
      //* @Value string write
      'name' : ZabbixValue.definition('Name', 'string', item['name'], true),
      //* @Node type
      //* @MetaType itemType
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Type of the item
      //*
      //* String representation of the type of the item. Can be set to an enum
      //* value.
      //*
      //* @Value enum[Zabbix Agent,SNMPv1 Agent,Zabbix Trapper,Simple Check,SNMPv2 Agent,Zabbix Internal,SNMPv3 Agent,Zabbix Agent (active),Zabbix Aggregate,Web Item,External Clock,Database Monitor,IPMI Agent,SSH Agent,Telnet Agent,Calculated,JMX Agent,SNMP Trap] write
      'type' : ZabbixValue.definition('Type', 'enum[${itemTypes.join(',')}]',
          itmType, true),
      //* @Node value_type
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Type of information the item provides.
      //*
      //* Value type is the type of information that is contained in the value.
      //* Can be set to one of the enum values.
      //*
      //* @Value enum[Numeric float,Character,Log,Numeric unsigned,text] write
      'value_type' : ZabbixValue.definition('Value Type',
          'enum[${valueTypes.join(',')}]', valType, true),
      //* @Node authtype
      //* @MetaType itemAuthtype
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* SSH authentication method. Used only by SSH agent items.
      //*
      //* @Value enum[password,public key] write
      'authtype' : ZabbixValue.definition(
          'SSH Authentication Method', 'enum[${authTypes.join(',')}]',
          authTypes[int.parse(item['authtype'])], true),
      //* @Node data_type
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Data type of the item.
      //*
      //* @Value enum[decimal,octal,hexadecimal,boolean] write
      'data_type' : ZabbixValue.definition('Data Type', 'enum[${dataTypes.join(',')}]',
          dataType, true),
      //* @Node delay_flex
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Flexible intervals as a serialized string
      //*
      //* @Value string write
      'delay_flex' : ZabbixValue.definition('Delay Flex', 'string', item['data_flex'], true),
      //* @Node delta
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Value that will be stored.
      //*
      //* @Value enum[as is,Delta (speed per second),Delta (simple change)] write
      'delta' : ZabbixValue.definition('Delta Type', 'enum[${deltaTypes.join(',')}]',
          deltaType, true),
      //* @Node description
      //* @MetaType itemDescription
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Description of the item.
      //* @Value string write
      'description' : ZabbixValue.definition('Description', 'string',
          item['description'], true),
      //* @Node error
      //* @MetaType itemError
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Error text if there are problems updating the item.
      //* @Value string
      'error' : ZabbixValue.definition('Error', 'string', item['error'], false),
      //* @Node flags
      //* @MetaType itemFlags
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Origin of the item.
      //*
      //* A string representation of the origin of the time. Possible values
      //* are Plain Item or Discovered Item.
      //*
      //* @Value string
      'flags' : ZabbixValue.definition('Flags', 'string',
          flags[item['flag']], false),
      //* @Node formula
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Custom multipler
      //* @Value number write
      'formula' : ZabbixValue.definition('Custom multiplier', 'number',
          num.parse(item['formula'], (_) => 1), true),
      //* @Node history
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Number of days to keep the item's history.
      //* @Value number write
      'history' : ZabbixValue.definition('History age', 'number',
          int.parse(item['history']), true),
      //* @Node inventory_link
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Id of the host inventory field that is populated by the item.
      //* @Value number write
      'inventory_link' : ZabbixValue.definition('Host Inventory Id', 'number',
          int.parse(item['inventory_link']), true),
      //* @Node ipmi_sensor
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* IPMI sensor. Used only by IPMI items.
      //* @Value string write
      'ipmi_sensor' : ZabbixValue.definition('IPMI Sensor', 'string',
          item['ipmi_sensor'], true),
      //* @Node lastclock
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Timestamp when the item was last updated.
      //* @Value string
      'lastclock' : ZabbixValue.definition('Last updated', 'string',
          lastClock.toIso8601String(), false),
      //* @Node lastns
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Nanoseconds when the item was last updated.
      //* @Value number
      'lastns' : ZabbixValue.definition('Last updated nanoseconds', 'number',
          int.parse(item['lastns']), false),
      //* @Node lastvalue
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Last value of the item.
      //* @Value string
      'lastvalue' : ZabbixValue.definition('Last Value', 'string',
          item['lastvalue'], false),
      //* @Node logtimefmt
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Format of the time in log entries. Only used by log items.
      //* @Value string write
      'logtimefmt' : ZabbixValue.definition('Log time format', 'string',
          item['logtimefmt'], true),
      //* @Node mtime
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Time when the monitored log file was last updated.
      //* @Value string
      'mtime' : ZabbixValue.definition('Monitored Log last updated', 'string',
          item['mtime'], false),
      //* @Node multiplier
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Whether to use a custom multiplier
      //* @Value number write
      'multiplier' : ZabbixValue.definition('Use custom multiplier', 'number',
          int.parse(item['multiplier']), true),
      //* @Node params
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Additional parameters depending on the type of the item.
      //*
      //* Parameters may be executed scripts for SSH/Telnet items; SQL query
      //* for database monitor items; or formula for calculated items.
      //*
      //* @Value string write
      'params' : ZabbixValue.definition('Additional Parameters', 'string',
          item['params'], true),
      //* @Node password
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Password used for authentication.
      //*
      //* Password that is required for simple check, SSH, telnet, database
      //* monitor and JMX items.
      //*
      //* @Value string write
      'passsword' : ZabbixValue.definition('Password', 'string', item['password'], true),
      //* @Node port
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Port monitored by the item. Used only by SNMP items.
      //* @Value string write
      'port' : ZabbixValue.definition('Port', 'string', item['port'], true),
      //* @Node prevvalue
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Previous value of the item.
      //* @Value string
      'prevvalue' : ZabbixValue.definition('Previous Value', 'string',
          item['prevvalue'], false),
      //* @Node privatekey
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Name of the private key file.
      //* @Value string write
      'privatekey' : ZabbixValue.definition('Private Key filename', 'string',
          item['privatekey'], true),
      //* @Node publickey
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Name of the public key file.
      //* @Value string write
      'publickey' : ZabbixValue.definition('Public Key filename', 'string',
          item['publickey'], true),
      //* @Node snmp
      //* @MetaType itemSNMP
      //* @Parent ZabbixItem
      //*
      //* Collection of Item SNMP configurations.
      'snmp' : {
        r'$type' : 'string',
        r'?value' : '',
        //* @Node snmp_community
        //* @Is zabbixValueNode
        //* @Parent itemSNMP
        //*
        //* SNMP community. Used only by SNMPv1 an SNMPv2 items.
        //* @Value string write
        'snmp_community' : ZabbixValue.definition('SNMP Community', 'string',
            item['snmp_community'], true),
        //* @Node snmp_oid
        //* @Is zabbixValueNode
        //* @Parent itemSNMP
        //*
        //* SNMP OID to query.
        //* @Value string write
        'snmp_oid' : ZabbixValue.definition('OID', 'string', item['snmp_oid'], true),
        //* @Node snmpv3_authpassphrase
        //* @Is zabbixValueNode
        //* @Parent itemSNMP
        //*
        //* SNMPv3 auth passphrase. Used only by SNMPv3 items.
        //* @Value string write
        'snmpv3_authpassphrase' : ZabbixValue.definition('SNMPv3 Passphrase', 'string',
            item['snmpv3_authpassphrase'], true),
        //* @Node snmpv3_authprotocol
        //* @Is zabbixValueNode
        //* @Parent itemSNMP
        //*
        //* SNMPv3 auth protocol. Used only by SNMPv3 items.
        //*
        //* @Value enum[MD5,SHA] write
        'snmpv3_authprotocol' : ZabbixValue.definition('SNMPv3 Protocol',
            'enum[${snmpv3AuthProtocols.join(',')}]', snmpv3AuthProto, true),
        //* @Node snmpv3_contextname
        //* @Is zabbixValueNode
        //* @Parent itemSNMP
        //*
        //* SNMPv3 context name. Used only by SNMPv3 items.
        //* @Value string write
        'snmpv3_contextname' : ZabbixValue.definition('SNMPv3 Context Name',
            'string', item['snmpv3_contextname'], true),
        //* @Node snmpv3_privpassphrase
        //* @Is zabbixValueNode
        //* @Parent itemSNMP
        //*
        //* SNMPv3 priv passphrase. Used only by SNMPv3 items.
        //* @Value string write
        'snmpv3_privpassphrase' : ZabbixValue.definition('SNMPv3 Priv Passphrase',
            'string', item['snmpv3_privpassphrase'], true),
        //* @Node snmpv3_privprotocol
        //* @Is zabbixValueNode
        //* @Parent itemSNMP
        //*
        //* SNMPv3 privacy protocol.
        //*
        //* @Value enum[DES,AES] write
        'snmpv3_privprotocol' : ZabbixValue.definition('SNMPv3 Priv Protocol',
            'enum[${snmpv3PrivProtocols.join(',')}]', snmpv3PrivProto, true),
        //* @Node snmpv3_securitylevel
        //* @Is zabbixValueNode
        //* @Parent itemSNMP
        //*
        //* SNMPv3 Security level. Used only by SNMPv3 items.
        //*
        //* @Value enum[noAuthNoPriv,authNoPriv,authPriv] write
        'snmpv3_securitylevel' : ZabbixValue.definition('SNMPv3 Security Level',
            'enum[${snmpv3SecurityLevels.join(',')}]', snmpv3Seclvl, true),
        //* @Node snmpv3_securityname
        //* @Is zabbixValueNode
        //* @Parent itemSNMP
        //*
        //* SNMPv3 Security name. Used only by SNMPv3 items.
        //* @Value string write
        'snmpv3_securityname' : ZabbixValue.definition('Security name', 'string',
            item['snmpv3_securityname'], true)
      },
      //* @Node state
      //* @MetaType itemState
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* State of the item.
      //*
      //* String representation of the state of the item.
      //* Possible values normal, or not supported
      //*
      //* @Value string
      'state' : ZabbixValue.definition('State', 'enum[${states.join(',')}]',
          states[int.parse(item['state'])], false),
      //* @Node status
      //* @MetaType itemStatus
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Status of the item.
      //*
      //* @Value enum[enabled,disabled] write
      'status' : ZabbixValue.definition('Status', 'enum[${statuses.join(',')}]',
          statuses[int.parse(item['status'])], true),
      //* @Node templateid
      //* @MetaType itemTemplateid
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Id of the parent template item.
      //* @Value string
      'templateid' : ZabbixValue.definition('Template Id', 'string',
          item['templateid'], false),
      //* @Node trapper_hosts
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Allowed hosts. Only used by trapper items.
      //* @Value string write
      'trapper_hosts' : ZabbixValue.definition('Trapper allowed hosts', 'string',
          item['trapper_hosts'], true),
      //* @Node trends
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Number of days to keep item's trends data.
      //* @Value number write
      'trends' : ZabbixValue.definition('Days of trends data', 'number',
          int.parse(item['trends']), true),
      //* @Node units
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Value units.
      //* @Value string write
      'units' : ZabbixValue.definition('Value units', 'string', item['units'], true),
      //* @Node username
      //* @MetaType itemUsername
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Username for authentication.
      //*
      //* Username that is required for simple check, SSH, telnet, database
      //* monitor and JMX items.
      //*
      //* @Value string write
      'username' : ZabbixValue.definition('Authentication username', 'string',
          item['username'], true),
      //* @Node valuemapid
      //* @Is zabbixValueNode
      //* @Parent ZabbixItem
      //*
      //* Id of the associated value map.
      //* @Value string write
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
    var lastClock = new DateTime.fromMillisecondsSinceEpoch(int.parse(updatedValues['lastclock']) * 1000);
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
        case 'lastclock':
          newVal = lastClock.toIso8601String();
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

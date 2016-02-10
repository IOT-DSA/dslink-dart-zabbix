library dslink.zabbix.nodes.zabbix_triggers;

import 'dart:async';
import 'dart:collection' show HashMap;

import 'package:dslink/utils.dart' show logger;

import 'common.dart';
import 'client.dart';

class ZabbixTrigger extends ZabbixChild {
  static final HashMap<String, ZabbixTrigger> _cache =
      new HashMap<String, ZabbixTrigger>();

  static const String isType = 'zabbixTriggerNode';

  static const _priorities = const ['not classified', 'information', 'warning',
    'average', 'high', 'disaster'];
  static const _statuses = const ['enabled', 'disabled'];
  static const _types = const ['single event', 'multple events'];
  static const _values = const { '0' : 'OK', '1' : 'Problem' };
  static const _states = const { '0' : 'Up to date', '1' : 'Unknown' };
  static const _flags = const { '0' : 'plain', '4' : 'discovered' };


  static ZabbixTrigger getById(String id) => _cache[id];

  static Map<String, dynamic> definition(Map trigger) {
    var flag = _flags[trigger['flags']];
    var state = _states[trigger['state']];
    var val = _values[trigger['value']];

    var lastChange = new DateTime.fromMillisecondsSinceEpoch(int.parse(
        trigger['lastchange']) * 1000);
    var priority = _priorities[int.parse(trigger['priority'])];
    var status = _statuses[int.parse(trigger['status'])];
    var type = _types[int.parse(trigger['type'])];

    var ret = {
      r'$is' : isType,
      r'$name' : trigger['description'],
      r'$type' : 'string',
      r'?value' : val,
      'triggerid' : ZabbixValue.definition('Trigger ID', 'string',
          trigger['triggerid'], false),
      'description' : ZabbixValue.definition('Description', 'string',
          trigger['description'], true),
      'expression' : ZabbixValue.definition('Expression', 'string',
          trigger['expression'], true),
      'comments' : ZabbixValue.definition('Comments', 'string',
          trigger['comments'], true),
      'error' : ZabbixValue.definition('Error', 'string', trigger['error'],
          false),
      'flags' : ZabbixValue.definition('Origin', 'string', flag, false),
      'lastchange' : ZabbixValue.definition('Last change', 'string',
          lastChange.toIso8601String(), false),
      'priority' : ZabbixValue.definition('Priority',
          'enum[${_priorities.join(',')}]', priority, true),
      'state' : ZabbixValue.definition('State', 'string', state, false),
      'status' : ZabbixValue.definition('Status', 'enum[${_statuses.join(',')}]',
          status, true),
      'templateid' : ZabbixValue.definition('Template ID', 'string',
          trigger['templateid'], false),
      'type' : ZabbixValue.definition('Type', 'enum[${_types.join(',')}]', type,
          true),
      'url' : ZabbixValue.definition('Url', 'string', trigger['url'], true)
    };
    return ret;
  }

  ZabbixTrigger(String path) : super(path);

  @override
  void onCreated() {
    _cache.putIfAbsent(name, () => this);
  }

  bool updateChild(String path, String valueName, newValue, oldValue) {
    var trigId = name;
    var sendVal;

    switch (valueName) {
      case 'priority':
        sendVal = _priorities.indexOf(newValue);
        break;
      case 'status':
        sendVal = _statuses.indexOf(newValue);
        break;
      case 'type':
        sendVal = _types.indexOf(newValue);
        break;
      default:
        sendVal = newValue;
    }

    var args = {
      'triggerid' : trigId,
      valueName : sendVal
    };

    _updateValue(path, args, oldValue);
    return false;
  }

  Future _updateValue(String path, Map params, oldValue) async {
    var cl = await client;
    var res = await cl.makeRequest(RequestMethod.triggerUpdate, params);
    if (res.containsKey('error')) {
      logger.warning('Error updating: "$params" Server error: ${res['error']}');
      provider.updateValue(path, oldValue);
    }
  }

  void update(Map updatedValues) {
    var flag = _flags[updatedValues['flags']];
    var state = _states[updatedValues['state']];
    var val = _values[updatedValues['value']];
    var lastChange = new DateTime.fromMillisecondsSinceEpoch(int.parse(
        updatedValues['lastchange']) * 1000);
    var priority = _priorities[int.parse(updatedValues['priority'])];
    var status = _statuses[int.parse(updatedValues['status'])];
    var type = _types[int.parse(updatedValues['type'])];

    updateValue(val);
    for (var key in updatedValues.keys) {
      var newVal;
      var nd = provider.getNode('$path/$key');
      switch (key) {
        case 'flags':
          newVal = flag;
          break;
        case 'state':
          newVal = state;
          break;
        case 'lastchange':
          newVal = lastChange.toIso8601String();
          break;
        case 'priority':
          newVal = priority;
          break;
        case 'status':
          newVal = status;
          break;
        case 'type':
          newVal = type;
          break;
        default:
          newVal = updatedValues[key];
          break;
      }

      nd?.updateValue(newVal);
    }
  }
}
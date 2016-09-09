library dslink.zabbix.nodes.zabbix_triggers;

import 'dart:async';
import 'dart:collection' show HashMap;

import 'package:dslink/utils.dart' show logger;

import 'common.dart';
import 'client.dart';

//* @Node
//* @MetaType ZabbixTrigger
//* @Is zabbixTriggerNode
//* @Parent Triggers
//*
//* Triggers for a Zabbix Host as defined on the remote server.
//*
//* Zabbix Triggers are the definition of an event which make cause an Event or
//* Alert to happen. The path name is the trigger Id and the display name is the
//* short description given to the trigger. The value is the current state
//* of the trigger and may be Ok, or Problem
//*
//* @Value string
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
      //* @Node triggerId
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Id of the trigger on the remote server.
      //*
      //* @Value string
      'triggerid' : ZabbixValue.definition('Trigger ID', 'string',
          trigger['triggerid'], false),
      //* @Node description
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Name of the trigger. Value may be set.
      //*
      //* @Value string
      'description' : ZabbixValue.definition('Description', 'string',
          trigger['description'], true),
      //* @Node expression
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Reduced trigger expression. May be set.
      //*
      //* @Value string
      'expression' : ZabbixValue.definition('Expression', 'string',
          trigger['expression'], true),
      //* @Node comments
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Additional comments to the trigger. Value may be set.
      //*
      //* @Value string
      'comments' : ZabbixValue.definition('Comments', 'string',
          trigger['comments'], true),
      //* @Node error
      //* @MetaType tError
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Error text if there have been problems updating the trigger.
      //*
      //* If an error occurred when updating the state of the trigger, the
      //* error text will appear here. Cannot be set.
      //*
      //* @Value string
      'error' : ZabbixValue.definition('Error', 'string', trigger['error'],
          false),
      //* @Node flags
      //* @MetaType tFlags
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Origin of the trigger.
      //*
      //* Indicate the origin of the trigger. Value may be plain or discovered.
      //*
      //* @Value string
      'flags' : ZabbixValue.definition('Origin', 'string', flag, false),
      //* @Node lastchange
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Timestamp indicating when the trigger last changed its state.
      //*
      //* @Value string
      'lastchange' : ZabbixValue.definition('Last change', 'string',
          lastChange.toIso8601String(), false),
      //* @Node priority
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Severity of the trigger.
      //*
      //* Priority is the string representation of the priority level of the
      //* trigger. May be modified as one of the enum values.
      //*
      //* @Value enum[not classified,information,warning,average,high,disaster]
      'priority' : ZabbixValue.definition('Priority',
          'enum[${_priorities.join(',')}]', priority, true),
      //* @Node state
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* State of the trigger.
      //*
      //* State is the string representation of the trigger's current state.
      //* Possible values are Up to date, Unknown.
      //*
      //* @Value string
      'state' : ZabbixValue.definition('State', 'string', state, false),
      //* @Node status
      //* @MetaType tStatus
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Whether the trigger is enabled or disabled.
      //*
      //* The enum values may be used to change the current
      //* state of the trigger.
      //*
      //* @Value enum[enabled,disabled]
      'status' : ZabbixValue.definition('Status', 'enum[${_statuses.join(',')}]',
          status, true),
      //* @Node templateid
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Id of the parent template trigger.
      //*
      //* @Value string
      'templateid' : ZabbixValue.definition('Template ID', 'string',
          trigger['templateid'], false),
      //* @Node type
      //* @MetaType tType
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* Whether the trigger can generate multiple problem events.
      //*
      //* The enum values may be set and used to change if the trigger can
      //* generate multiple problem events.
      //*
      //* @Value enum[single event,multple events]
      'type' : ZabbixValue.definition('Type', 'enum[${_types.join(',')}]', type,
          true),
      //* @Node url
      //* @MetaType tUrl
      //* @Is zabbixValueNode
      //* @Parent ZabbixTrigger
      //*
      //* The Url associated with the trigger. May be set.
      //*
      //* @Value string
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

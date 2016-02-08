library dslink.zabbix.nodes.zabbix_triggers;

import 'common.dart';

class ZabbixTrigger extends ZabbixChild {
  static const String isType = 'zabbixTriggerNode';

  static const _priorities = const ['not classified', 'information', 'warning',
    'average', 'high', 'disaster'];
  static const _statuses = const ['enabled', 'disabled'];
  static const _types = const ['single event', 'multple events'];

  static Map<String, dynamic> definition(Map trigger) {
    final flags = { '0' : 'plain', '4' : 'discovered' };
    var flag = flags[trigger['flags']];

    final states = { '0' : 'Up to date', '1' : 'Unknown' };
    var state = states[trigger['state']];

    final values = { '0' : 'OK', '1' : 'Problem' };
    var val = values[trigger['value']];

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

  bool updateChild(String path, String valueName, newValue, oldValue) {
    // TODO: Complete this.
    return true;
  }
}
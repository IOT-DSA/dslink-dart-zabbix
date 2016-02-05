library dslink.zabbix.nodes.zabbix_hostgroup;

import 'common.dart';
import 'zabbix_hostgroup_commands.dart';

class ZabbixHostGroup extends ZabbixChild {
  static const String isType = 'zabbixHostgroupNode';

  static Map<String, dynamic> definition(Map hostgroup) {
    var flags = (hostgroup['flags'] == 0 ? 'plain' : 'discovered');
    bool internal = hostgroup['internal'] == "1";

    var ret = {
      r'$is' : isType,
      r'$name' : hostgroup['name'],
      'flags' : ZabbixValue.definition('Flags', 'string', flags, false),
      'internal' : ZabbixValue.definition('Internal', 'bool', internal, false),
      RenameHostGroup.pathName : RenameHostGroup.definition(hostgroup['name'])
    };
    if (!internal) {
      ret[DeleteHostGroup.pathName] = DeleteHostGroup.definition();
    }
    return ret;
  }

  ZabbixHostGroup(String path) : super(path);

  bool updateChild(String path, String valueName, newValue, oldValue) => true;
}
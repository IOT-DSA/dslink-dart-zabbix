library dslink.zabbix.nodes.zabbix_hostgroup;

import 'dart:async';

import 'package:dslink/dslink.dart';
import 'package:dslink/utils.dart' show logger;

import 'common.dart';
import 'client.dart';
import 'zabbix_node.dart';
import 'zabbix_hostgroup_commands.dart';

class ZabbixHostGroup extends ZabbixChild {
  static const String isType = 'zabbixHostgroupNode';

  static Map<String, dynamic> definition(Map hostgroup) {
    var flags = (hostgroup['flags'] == '0' ? 'plain' : 'discovered');
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

class CreateHostGroup extends SimpleNode {
  static const String isType = 'zabbixCreateHostgroup';
  static const String pathName = 'Create_Hostgroup';
  static Map<String, dynamic> definition() => {
    r'$is' : isType,
    r'$name' : 'Create Hostgroup',
    r'$invokable' : 'write',
    r'$params' : [
      {
        'name' : 'name',
        'type' : 'string',
        'placeholder' : 'Hostgroup Name'
      }
    ],
    r'$columns' : [
      {
        'name' : 'success',
        'type' : 'bool',
        'default' : false
      },
      {
        'name' : 'message',
        'type' : 'string',
        'default': ''
      }
    ]
  };

  CreateHostGroup(String path) : super(path);

  @override
  Future<Map<String, dynamic>> onInvoke(Map<String, dynamic> params) async {
    var ret = { 'success' : false, 'message' : '' };
    if (params['name'] == null || params['name'].isEmpty) {
      ret['message'] = 'Name is required';
      return ret;
    }

    var p = parent;
    while (p is! ZabbixChild && p is! ZabbixNode) {
      p = p.parent;
      if (p == null) break;
    }

    if (p == null) {
      ret['message'] = 'Internal error finding client';
      return ret;
    }

    var client = await p.client as ZabbixClient;
    var args = { 'name': params['name'] };
    var result = await client.makeRequest(RequestMethod.hostgroupCreate, args);
    if (result.containsKey('error')) {
      logger.warning('Error creating Hostgroup: ${result['error']}');
      ret['message'] = result['error']['data'];
    } else {
      var groupId = result['result']['groupids'].first;
      var def = {
        'groupid' : groupId,
        'name' : params['name'],
        'flags': '0',
        'internal': '0'
      };
      provider.addNode('${parent.path}/$groupId',
          ZabbixHostGroup.definition(def));
      ret['success'] = true;
      ret['message'] = 'Success!';
    }

    return ret;
  }
}
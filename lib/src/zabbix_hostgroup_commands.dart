library dslink.zabbix.nodes.zabbix_hostgroup.commands;

import 'dart:async';

import 'package:dslink/dslink.dart';
import 'package:dslink/utils.dart';

import 'common.dart';
import 'client.dart';

class RenameHostGroup extends SimpleNode {
  static const String isType = 'zabbixRenameHostgroup';
  static const String pathName = 'Rename_Hostgroup';
  static Map<String, dynamic> definition(String name) => {
    r'$is' : isType,
    r'$name' : 'Rename Hostgroup',
    r'$invokable' : 'write',
    r'$params' : [
      {
        'name' : 'name',
        'type' : 'string',
        'default' : name
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

  RenameHostGroup(String path) : super(path);

  @override
  Future<Map<String, dynamic>> onInvoke(Map<String, dynamic> params) async {
    var ret = { 'success' : false, 'message' : '' };
    if (params['name'] == null || params['name'].isEmpty) {
      ret['message'] = 'Name is required';
      return ret;
    }
    var client = await (parent as ZabbixChild).client;
    var hgId = parent.name;
    var args = { 'groupid' : hgId, 'name' : params['name'] };
    var result = await client.makeRequest(RequestMethod.hostgroupUpdate, args);
    if (result.containsKey('error')) {
      logger.warning('Error renaming hostgroup: ${result['error']}');
      ret['message'] = result['error']['data'];
    } else {
      configs[r'$params'] = [{
        'name' : 'name',
        'type' : 'string',
        'default' : params['name']
      }];
      parent.displayName = params['name'];
      ret['success'] = true;
      ret['message'] = 'Success!';
    }

    return ret;
  }
}

class DeleteHostGroup extends SimpleNode {
  static const String isType = 'zabbixDeleteHostgroup';
  static const String pathName = 'Delete_Hostgroup';
  static Map<String, dynamic> definition() => {
    r'$is' : isType,
    r'$name' : 'Delete Hostgroup',
    r'$invokable' : 'write',
    r'$params' : [],
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

  DeleteHostGroup(String path) : super(path);

  @override
  Future<Map<String, dynamic>> onInvoke(Map<String, dynamic> params) async {
    var ret = { 'success' : false, 'message' : '' };

    var client = await (parent as ZabbixChild).client;
    var args = [parent.name];

    var result = await client.makeRequest(RequestMethod.hostgroupDelete, args);
    if (result.containsKey('error')) {
      logger.warning('Error deleting Hostgroup: ${result['error']}');
      ret['message'] = result['error']['data'];
    } else {
      ret['success'] = true;
      ret['message'] = 'Success';
      provider.removeNode(parent.path);
    }

    return ret;
  }
}
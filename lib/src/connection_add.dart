library dslink.zabbix.nodes.connection_add;

import 'dart:async';

import 'package:dslink/dslink.dart';
import 'package:dslink/nodes.dart' show NodeNamer;

import 'client.dart';
import 'zabbix_node.dart';


//* @Action Add_Connection
//* @Is addConnectionNode
//* @Parent root
//*
//* Adds a connection to a Zabbix Server.
//*
//* Add Connection will attempt to connect to the specified server with the
//* provided credentials. If successful it will add a ZabbixNode to the root
//* of the link with the specified name.
//*
//* @Param name string Name to specify the server. Name becomes the path of
//* the new ZabbixNode when added.
//* @Param address string Address is the full URL to the ZabbixServer
//* @Param username string Username used to authenticate to the server.
//* @Param password string Password used to authenticate to the server.
//* @Param refreshRate number Refresh Rate is the number of seconds between
//* polling the server for new information.
//*
//* @Return value
//* @Column success bool Success is true when the action is successful, and
//* false if the action failed.
//* @Column message string Message is Success! when the action is successful,
//* and provides an error message if the action failed.
class AddConnection extends SimpleNode {
  static const String isType = 'addConnectionNode';
  static const String pathName = 'Add_Connection';
  static Map<String, dynamic> definition() => {
    r'$is' : isType,
    r'$name' : 'Add Connection',
    r'$invokable' : 'write',
    r'$params' : [
      {
        'name' : 'name',
        'type' : 'string',
        'placeholder' : 'Server Name'
      },
      {
        'name' : 'address',
        'type' : 'string',
        'placeholder' : 'http://your.server.com/zabbix'
      },
      {
        'name' : 'username',
        'type' : 'string',
        'placeholder' : 'Username'
      },
      {
        'name' : 'password',
        'type' : 'string',
        'editor' : 'password',
        'placeholder' : 'Password'
      },
      {
        'name' : 'refreshRate',
        'type' : 'number',
        'min' : 0.01,
        'max' : 60,
        'default' : 30
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

  LinkProvider _link;

  AddConnection(String path, this._link) : super(path);

  @override
  Future<Map<String, dynamic>> onInvoke(Map<String, dynamic> params) async {
    var ret = { 'success' : false, 'message' : '' };

    if (params['name'] == null || params['name'].trim().isEmpty) {
      ret['message'] = 'Server name is required.';
      return ret;
    }
    if (params['address'] == null || params['address'].trim().isEmpty) {
      ret['message'] = 'Server address is required';
    }

    var client = new ZabbixClient(params['address'],
                      params['username'],
                      params['password']);

    var res = await client.authenticate();
    ret['success'] = res['success'];
    if (res['success'] == true) {
      var name = NodeNamer.createName(params['name'].trim());
      _link.addNode('/$name', ZabbixNode.definition(params));
      ret['message'] = 'Success!';
      _link.save();
    } else {
      ret['message'] = res['error'];
    }

    return ret;
  }

}

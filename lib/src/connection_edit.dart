library dslink.zabbix.nodes.connection_edit;

import 'dart:async';

import 'package:dslink/dslink.dart';

import 'zabbix_node.dart';
import 'client.dart';

//* @Action Edit_Connection
//* @Is editConnectionNode
//* @Parent ZabbixNode
//*
//* Edit the connection details.
//*
//* Edit connection updates the connection details and will verify that the new
//* parameters are able to authenticate against the remote server. On success
//* the action will update the backing client with the new connection details.
//*
//* @Param address string Address is the remote address of the Zabbix Server.
//* @Param username string Username required to authenticate with the remote server.
//* @Param password string Password required to authenticate with the remote server.
//* @Param refreshRate number RefreshRate is the number of seconds between
//* polling for updates from the remote server.
//*
//* @Return value
//* @Column success bool Success returns true if the action is successful;
//* false on failure.
//* @Column message string Message returns Success! if the action is successful;
//* an error message is return on failure.
class EditConnection extends SimpleNode {
  static const String isType = 'editConnectionNode';
  static const String pathName = 'Edit_Connection';
  static Map<String, dynamic> definition(Map params) => {
    r'$is' : isType,
    r'$name' : 'Edit Connection',
    r'$invokable' : 'write',
    r'$params' : [
      {
        'name' : 'address',
        'type' : 'string',
        'default' : params['address']
      },
      {
        'name' : 'username',
        'type' : 'string',
        'default' : params['username']
      },
      {
        'name' : 'password',
        'type' : 'string',
        'editor' : 'password',
        'default' : params['password']
      },
      {
        'name' : 'refreshRate',
        'type' : 'number',
        'default' : params['refreshRate']
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

  EditConnection(String path) : super(path);

  @override
  Future<Map<String, dynamic>> onInvoke(Map<String, dynamic> params) async {
    var ret = { 'success' : false, 'message' : '' };

    if (params['address'] == null || params['address'].trim().isEmpty) {
      ret['message'] = 'Server address is required';
    }

    var client = new ZabbixClient(params['address'], params['username'],
                      params['password']);

    var auth = await client.authenticate();

    if (auth['success']) {
      ret['success'] = true;
      ret['message'] = 'Success!';
      var p = (parent as ZabbixNode);
      p.updateConfig(params, client);
    } else {
      ret['message'] = auth['error'];
    }

    return ret;
  }
}

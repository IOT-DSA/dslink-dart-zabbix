library dslink.zabbix.nodes.connection_remove;

import 'package:dslink/dslink.dart';

//* @Action Remove_Connection
//* @Is remoteConnectionNode
//* @Parent ZabbixNode
//*
//* Remove the connection to the remote server.
//*
//* Removes the Zabbix server from the link and closes the connection to the
//* remote server. This action should not fail.
//*
//* @Return value
//* @Column success bool Success is true when action completes successfully;
//* false on failure.
//* @Column message string Message returns Success! when action completes
//* successfully. Returns an error message on failure.
class RemoveConnection extends SimpleNode {
  static const String isType = 'removeConnectionNode';
  static const String pathName = 'Remove_Connection';
  static Map<String, dynamic> definition() => {
    r'$is' : isType,
    r'$name' : 'Remove Connection',
    r'$invokable' : 'write',
    r'$params' : [
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
  RemoveConnection(String path, this._link) : super(path);

  @override
  Map<String, dynamic> onInvoke(Map<String, dynamic> params) {
    var ret = { 'success' : false, 'message' : '' };

    _link.removeNode(parent.path);
    ret['success'] = true;
    ret['message'] = 'Success!';
    return ret;
  }
}

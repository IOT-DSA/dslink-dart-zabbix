library dslink.zabbix.nodes.connection_remove;

import 'package:dslink/dslink.dart';

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
library dslink.zabbix.nodes.common;

import 'dart:async';

import 'package:dslink/dslink.dart';

import 'client.dart';
import 'zabbix_node.dart';

abstract class ZabbixChild extends SimpleNode {
  Future<ZabbixClient> get client => _getClient();
  ZabbixClient _client;

  Future<ZabbixNode> get rootParent async {
    if (_rootParent == null) await _getClient();

    return _rootParent;
  }

  ZabbixNode _rootParent;

  ZabbixChild(String path) : super(path) {
    serializable = false;
  }

  Future<ZabbixClient> _getClient() async {
    if (_client != null && _rootParent != null && !_client.expired) {
      return _client;
    }

    var p = parent;
    while (p is! ZabbixNode && p is! ZabbixChild) {
      p = p.parent;
      if (p == null) break;
    }

    if (p == null) {
      throw new StateError('Unable to locate client');
    }
    _client = await p.client;
    _rootParent = await p.rootParent;
    return _client;
  }

  void addSubscription() {
    _rootParent.addSubscription(this);
  }

  bool updateChild(String path, String valueName, newValue, oldValue);
}

class ZabbixValue extends ZabbixChild {
  static final String isType = 'zabbixValueNode';
  static Map<String, dynamic> definition(String name, String type,
                              dynamic value, bool writable) => {
      r'$is' : isType,
      r'$name' : name,
      r'$type' : type,
      r'?value' : value,
      r'$writable' : (writable ? 'write' : 'never')
  };

  ZabbixValue(String path) : super(path);

  bool updateChild(String path, String valueName, newValue, oldValue) {
    var p = parent;
    while (p is! ZabbixChild && p is! ZabbixNode) {
      p = p.parent;
      if (p == null) break;
    }
    if (p != null) {
      print(p.name);
    }
    var ret = p?.updateChild(path, name, newValue, oldValue);
    return ret ?? false;
  }

  @override
  bool onSetValue(Object value) => updateChild(path, name, value, this.value);

// TODO: Overried onSubscribe/onUnsubscribe
}
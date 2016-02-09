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

  Future addSubscription(String id, String type, String valueName) async {
    var rootPar = await rootParent;
    rootPar.addSubscription(id, type, valueName);
  }

  Future removeSubscription(String id, String type, String valueName) async {
    var rootPar = await rootParent;
    rootPar.removeSubscription(id, type, valueName);
  }

  @override
  void onSubscribe({String valueName: '_rootVal'}) {
    var id = name;
    var myType = configs[r'$is'];
    addSubscription(id, myType, valueName);
  }

  @override
  void onUnsubscribe({String valueName: '_rootVal'}) {
    var id = name;
    var myType = configs[r'$is'];
    removeSubscription(id, myType, valueName);
  }

  bool updateChild(String path, String valueName, newValue, oldValue);

  void update(Map values);
}

class ZabbixValue extends ZabbixChild {
  static final String isType = 'zabbixValueNode';
  static Map<String, dynamic> definition(String name, String type,
                              dynamic value, bool writable) {
    var ret = {
      r'$is' : isType,
      r'$name' : name,
      r'$type' : type,
      r'?value' : value,
    };

    if (writable) ret[r'$writable'] = 'write';
    return ret;
  }

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
  @override
  void onSubscribe({String valueName: '_rootVal'}) {
    (parent as ZabbixChild).onSubscribe(valueName: name);
  }

  @override
  void onUnsubscribe({String valueName: '_rootVal'}) {
    (parent as ZabbixChild).onUnsubscribe(valueName: name);
  }

  void update(Map value) {
  }

}
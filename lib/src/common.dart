library dslink.zabbix.nodes.common;

import 'dart:async';

import 'package:dslink/dslink.dart';

import 'client.dart';
import 'zabbix_node.dart';

abstract class ZabbixChild extends SimpleNode {
  Future<ZabbixClient> get client => _getClient();
  ZabbixClient _client;

  ZabbixNode get rootParent {
    if (_rootParent == null) {
      _getClient();
    }
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

    while (p is! ZabbixNode || p is! ZabbixChild) {
      p = p.parent;
      if (p == null) break;
    }

    if (p == null) {
      throw new StateError('Unable to locate client');
    }
    _client = await p.client;
    _rootParent = p.rootParent;
    return _client;
  }

  void addSubscription() {
    _rootParent.addSubscription(this);
  }

}
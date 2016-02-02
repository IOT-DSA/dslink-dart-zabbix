library dslink.zabbix.nodes.zabbix;

import 'dart:async';

import 'package:dslink/dslink.dart';
import 'client.dart';
import 'connection_remove.dart';

class ZabbixNode extends SimpleNode {
  static const String isType = 'zabbixNode';
  static Map<String, dynamic> definition(Map params) => {
    r'$is' : isType,
    r'$$zb_addr' : params['address'],
    r'$$zb_user' : params['username'],
    r'$$zb_pass' : params['password'],
    r'$$zb_refresh' : params['refreshRate'],
    RemoveConnection.pathName : RemoveConnection.definition()
  };

  ZabbixNode(String path) : super(path);

  Future<ZabbixClient> get client => _clientComp.future;

  ZabbixClient _client;
  int _refreshRate;
  Completer<ZabbixClient> _clientComp;

  @override
  void onCreated() {
    var username = getConfig(r'$$zb_user');
    var password = getConfig(r'$$zb_pass');
    var address = getConfig(r'$$zb_addr');
    _refreshRate = int.parse(getConfig(r'$$zb_refresh'), onError: (_) => 30);

    _client = new ZabbixClient(address, username, password);
    _clientComp.complete(_client);
  }

  @override
  void onRemoving() {
    _client.close();
  }
}
library dslink.zabbix.nodes.zabbix;

import 'dart:async';

import 'package:dslink/dslink.dart';
import 'client.dart';
import 'common.dart';
import 'connection_edit.dart';
import 'connection_remove.dart';

class ZabbixNode extends SimpleNode {
  static const String isType = 'zabbixNode';
  static Map<String, dynamic> definition(Map params) => {
    r'$is' : isType,
    r'$$zb_addr' : params['address'],
    r'$$zb_user' : params['username'],
    r'$$zb_pass' : params['password'],
    r'$$zb_refresh' : params['refreshRate'],
    EditConnection.pathName : EditConnection.definition(params),
    RemoveConnection.pathName : RemoveConnection.definition()
  };

  ZabbixNode(String path, this._link) : super(path) {
    _clientComp = new Completer<ZabbixClient>();
  }

  Future<ZabbixClient> get client => _clientComp.future;
  ZabbixNode get rootParent => this;

  ZabbixClient _client;
  int _refreshRate;
  Completer<ZabbixClient> _clientComp;
  LinkProvider _link;

  @override
  void onCreated() {
    var username = getConfig(r'$$zb_user');
    var password = getConfig(r'$$zb_pass');
    var address = getConfig(r'$$zb_addr');
    _refreshRate = getConfig(r'$$zb_refresh');

    _client = new ZabbixClient(address, username, password);

    _client.authenticate().then((_) {
      _clientComp.complete(_client);
    });
  }

  @override
  void onRemoving() {
    _client.close();
  }

  void updateConfig(Map params, ZabbixClient newClient) {
    configs[r'$$zb_user'] = params['username'].trim();
    configs[r'$$zb_pass'] = params['password'];
    configs[r'$$zb_addr'] = params['address'];
    configs[r'$$zb_refresh'] = params['refreshRate'];

    if (newClient != _client) {
      _client.close();
      _client = newClient;
      _clientComp = new Completer()..complete(_client);
    }

    _link.removeNode('$path/${EditConnection.pathName}');
    _link.addNode('$path/${EditConnection.pathName}',
          EditConnection.definition(params));

    _link.save();
  }

  void addSubscription(ZabbixChild child) {
    // TODO: Add implementation for Subscriptions/Timers
  }
}
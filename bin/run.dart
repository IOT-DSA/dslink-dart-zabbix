library dslink.zabbix;

import 'dart:async';

import 'package:dslink/client.dart';

import 'package:dslink_zabbix/zabbix_nodes.dart';

Future main(List<String> args) async {
  LinkProvider link;

  link = new LinkProvider(args, 'Zabbix-', command: 'run',
      profiles: {
        ZabbixNode.isType : (String path) => new ZabbixNode(path, link),
        AddConnection.isType : (String path) => new AddConnection(path, link),
        RemoveConnection.isType : (String path) => new RemoveConnection(path, link),
        EditConnection.isType : (String path) => new EditConnection(path),
        ZabbixHost.isType : (String path) => new ZabbixHost(path),
        ZabbixValue.isType : (String path) => new ZabbixValue(path),
        ZabbixItem.isType : (String path) => new ZabbixItem(path),
        ZabbixAlert.isType : (String path) => new ZabbixAlert(path)
      }, autoInitialize: false);

  link.init();
  link.addNode('/${AddConnection.pathName}', AddConnection.definition());
  await link.connect();
}
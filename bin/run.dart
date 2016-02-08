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
        ZabbixHostGroup.isType : (String path) => new ZabbixHostGroup(path),
        RenameHostGroup.isType : (String path) => new RenameHostGroup(path),
        DeleteHostGroup.isType : (String path) => new DeleteHostGroup(path),
        CreateHostGroup.isType : (String path) => new CreateHostGroup(path),
        ZabbixHost.isType : (String path) => new ZabbixHost(path),
        ZabbixValue.isType : (String path) => new ZabbixValue(path),
        ZabbixItem.isType : (String path) => new ZabbixItem(path),
        ZabbixAlert.isType : (String path) => new ZabbixAlert(path),
        ZabbixEvent.isType : (String path) => new ZabbixEvent(path),
        AcknowledgeEvent.isType : (String path) => new AcknowledgeEvent(path)
      }, autoInitialize: false);

  link.init();
  link.addNode('/${AddConnection.pathName}', AddConnection.definition());
  await link.connect();
}
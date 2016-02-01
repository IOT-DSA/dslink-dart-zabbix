library dslink.zabbix;

import 'dart:async';

import 'package:dslink/client.dart';

import 'package:dslink_zabbix/zabbix_nodes.dart';

Future main(List<String> args) async {
  LinkProvider link;

  link = new LinkProvider(args, 'Zabbix-', command: 'run',
      profiles: {
        AddConnection.isType : (String path) => new AddConnection(path)
      }, autoInitialize: false);

  link.init();
  link.addNode('/${AddConnection.pathName}', AddConnection.definition());
  await link.connect();
}
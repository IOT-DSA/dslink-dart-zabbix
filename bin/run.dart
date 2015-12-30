library dslink.zabbix;

import 'dart:async';

import 'package:dslink/client.dart';

Future main(List<String> args) async {
  LinkProvider link;

  link = new LinkProvider(args, 'Zabbix-', command: 'run',
      profiles: {

      });

  // link.addNode('/${AddConnection.pathName}', AddConnection.definition());
  link.init();
  await link.connect();
}
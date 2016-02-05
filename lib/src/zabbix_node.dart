library dslink.zabbix.nodes.zabbix;

import 'dart:async';

import 'package:dslink/dslink.dart';
import 'package:dslink/nodes.dart';
import 'package:dslink/utils.dart';

import 'client.dart';
import 'common.dart';
import 'connection_edit.dart';
import 'connection_remove.dart';
import 'zabbix_alert.dart';
import 'zabbix_host.dart';
import 'zabbix_hostgroup.dart';
import 'zabbix_item.dart';

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

    var hostIds = [];
    _client.authenticate().then((_) {
      return _clientComp.complete(_client);
    }).then((_) {
      var params = {'selectHosts' : 'extend'};
      return _client.makeRequest(RequestMethod.hostgroupGet, params);
    }).then((result) {
      if (result.containsKey('error')) {
        logger.warning('Error polling hostgroups: ${result['error']}');
        return null;
      }
      var groupList = result['result'] as List;
      var hgPath = provider.getOrCreateNode('$path/HostGroups');
      for (Map gp in groupList) {
        var name = gp['groupid'];
        var hgNode = provider.addNode('${hgPath.path}/$name',
            ZabbixHostGroup.definition(gp));
        if (gp['hosts'] != null && gp['hosts'].isNotEmpty) {
          for (Map host in gp['hosts']) {
            var hName = host['hostid'];
            provider.addNode('${hgNode.path}/$hName',
                ZabbixHost.definition(host));
            hostIds.add(hName);
          }
        }
      }

//      var hostList = result['result'] as List;
//      var hostNode = provider.getOrCreateNode('$path/Hosts');
//      for (Map host in hostList) {
//        var name = NodeNamer.createName(host['hostid']);
//        provider.addNode('${hostNode.path}/$name', ZabbixHost.definition(host));
//        hostIds.add(host['hostid']);
//      }
      return _client.makeRequest(RequestMethod.itemGet, {'hostids' : hostIds});
    }).then((result) {
      if (result == null) return null;
      if (result.containsKey('error')) {
        logger.warning('Error polling items: ${result['error']}');
        return null;
      }
      for (Map tmp in result['result']) {
        var host = ZabbixHost.getById(tmp['hostid']);
        if (host == null) {
          logger.warning("Can't get node: ${tmp['hostid']}");
          return null;
        }
        var path = provider.getOrCreateNode('${host.path}/items');
        var name = NodeNamer.createName(tmp['itemid']);
        provider.addNode('${path.path}/$name', ZabbixItem.definition(tmp));
      }
      return _client.makeRequest(RequestMethod.alertGet, null);
    }).then((Map result) {
      if (result == null) return null;
      if (result.containsKey('error')) {
        logger.warning('Error retreiving alerts: ${result['error']}');
        return null;
      }
      if (result['result'] != null && result['result'].isNotEmpty) {
        var alertNd = provider.getOrCreateNode('$path/alerts');
        for (Map tmp in result['result']) {
          provider.addNode('${alertNd.path}/${tmp['alertid']}',
              ZabbixAlert.definition(tmp));
        }
      }
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

  void updateChild(String path, String name, value) {}
}
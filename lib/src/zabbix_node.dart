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
import 'zabbix_event.dart';
import 'zabbix_host.dart';
import 'zabbix_hostgroup.dart';
import 'zabbix_item.dart';
import 'zabbix_triggers.dart';

class ZabbixNode extends SimpleNode {
  static const String isType = 'zabbixNode';
  static Map<String, dynamic> definition(Map params) => {
    r'$is' : isType,
    r'$$zb_addr' : params['address'],
    r'$$zb_user' : params['username'],
    r'$$zb_pass' : params['password'],
    r'$$zb_refresh' : params['refreshRate'],
    'HostGroups' : {
      CreateHostGroup.pathName : CreateHostGroup.definition()
    },
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
      _clientComp.complete(_client);
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

      var eventArgs = {
        'select_acknowledges' : 'extend',
        'hostids' : hostIds,
        'selectHosts' : 'hostid'
      };

      var trigArgs = {
        'hostids' : hostIds,
        'expandComment' :  true,
        'expandDescription' : true,
        'expandExpression' : true,
        'selectHosts' : 'hostid',
        'selectFunctions' : 'expand'
      };
      _client.makeRequest(RequestMethod.eventGet, eventArgs).then(_populateEvents);
      _client.makeRequest(RequestMethod.alertGet, null).then(_populateAlerts);
      _client.makeRequest('trigger.get', trigArgs).then(_populateTriggers);
      _client.makeRequest(RequestMethod.itemGet, {'hostids' : hostIds})
        .then(_populateItems);
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

  bool updateChild(String path, String name, newValue, oldValue) => true;

  void _populateAlerts(Map result) {
    if (result.containsKey('error')) {
      logger.warning('Error retreiving alerts: ${result['error']}');
      return;
    }
    if (result['result'] != null && result['result'].isNotEmpty) {
      var alertNd = provider.getOrCreateNode('$path/alerts');
      for (Map tmp in result['result']) {
        provider.addNode('${alertNd.path}/${tmp['alertid']}',
            ZabbixAlert.definition(tmp));
      }
    }
  }

  void _populateEvents(Map result) {
    if (result.containsKey('error')) {
      logger.warning('Error retreiving events: ${result['error']}');
      return;
    }
    if (result['result'] != null && result['result'].isNotEmpty) {
      for (Map evnt in result['result']) {
        var host = ZabbixHost.getById(evnt['hosts'][0]['hostid']);
        if (host != null) {
          var evntNode = provider.getOrCreateNode('${host.path}/Events');
          provider.addNode('${evntNode.path}/${evnt['eventid']}',
              ZabbixEvent.definition(evnt));
        } else {
          logger.fine('No associated host. $evnt');
        }
      }
    }
  }

  void _populateItems(Map result) {
    if (result.containsKey('error')) {
      logger.warning('Error polling items: ${result['error']}');
      return;
    }
    for (Map tmp in result['result']) {
      var host = ZabbixHost.getById(tmp['hostid']);
      if (host == null) {
        logger.warning("Can't get node: ${tmp['hostid']}");
        continue;
      }
      var path = provider.getOrCreateNode('${host.path}/Items');
      var name = NodeNamer.createName(tmp['itemid']);
      provider.addNode('${path.path}/$name', ZabbixItem.definition(tmp));
    }
  }

  void _populateTriggers(Map result) {
    if (result.containsKey('error')) {
      logger.warning('Error polling Triggers: ${result['error']}');
      return;
    }
    for (var trig in result['result']) {
      var host = ZabbixHost.getById(trig['hosts'][0]['hostid']);
      if (host == null) {
        logger.fine('Unable to find host for: $trig');
        continue;
      }
      var trigNd = provider.getOrCreateNode('${host.path}/Triggers');
      provider.addNode('${trigNd.path}/${trig['triggerid']}',
          ZabbixTrigger.definition(trig));
    }
  }

}
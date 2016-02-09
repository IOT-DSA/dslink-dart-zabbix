library dslink.zabbix.nodes.zabbix;

import 'dart:async';
import 'dart:collection' show HashMap;

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
    _subscriptions = new HashMap();
  }

  Future<ZabbixClient> get client => _clientComp.future;
  ZabbixNode get rootParent => this;

  ZabbixClient _client;
  int _refreshRate;
  Completer<ZabbixClient> _clientComp;
  LinkProvider _link;
  HashMap<String, Set> _subscriptions;
  Timer _refreshTimer;

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

      var trigArgs = {
        'hostids' : hostIds,
        'expandComment' :  true,
        'expandDescription' : true,
        'expandExpression' : true,
        'selectHosts' : 'hostid',
        'selectFunctions' : 'expand'
      };
      _client.makeRequest(RequestMethod.triggerGet, trigArgs)
          .then(_populateTriggers);
      _client.makeRequest(RequestMethod.itemGet, {'hostids' : hostIds})
        .then(_populateItems);
    });
    var dur = new Duration(milliseconds: _refreshRate * 1000);
    _refreshTimer = new Timer.periodic(dur, _refreshCallback);
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

  void addSubscription(String parId, String type) {
    // TODO: Add implementation for Subscriptions/Timers
    print('Subscription for: ${parId} which is: $type');

    Set set = _subscriptions.putIfAbsent(type, () => new Set());
    set.add(parId);
  }

  void removeSubscription(String parId, String type) {
    var set = _subscriptions[type];
    set?.remove(parId);
  }

  bool updateChild(String path, String name, newValue, oldValue) => true;

  void _populateAlerts(Map result) {
    if (result.containsKey('error')) {
      logger.warning('Error retreiving alerts: ${result['error']}');
      return;
    }
    if (result['result'] != null && result['result'].isNotEmpty) {
      for (Map tmp in result['result']) {
        var evnt = ZabbixEvent.getById(tmp['eventid']);
        var alertNd = provider.getOrCreateNode('${evnt.path}/Alerts');
        provider.addNode('${alertNd.path}/${tmp['alertid']}',
            ZabbixAlert.definition(tmp));
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

    var eventArgs = {
      'select_acknowledges' : 'extend',
      'selectHosts' : 'hostid'
    };

    _client.makeRequest(RequestMethod.alertGet, null).then(_populateAlerts);
    _client.makeRequest(RequestMethod.eventGet, eventArgs).then(_populateEvents);
  }

  void _populateEvents(Map result) {
    if (result.containsKey('error')) {
      logger.warning('Error retreiving events: ${result['error']}');
      return;
    }

    if (result['result'] != null && result['result'].isNotEmpty) {
      for (Map evnt in result['result']) {
        if (evnt['object'] != '0') continue;

        var trig = ZabbixTrigger.getById(evnt['objectid']);
        if (trig != null) {
          var evntNode = provider.getOrCreateNode('${trig.path}/Events');
          provider.addNode('${evntNode.path}/${evnt['eventid']}',
              ZabbixEvent.definition(evnt));
        } else {
          logger.fine('No associated host. $evnt');
        }
      }
    }
  }

  Future _refreshCallback(Timer t) async {
    print('Calling refresh callback');
    print('Subscriptions: $_subscriptions');
    for (var reqType in _subscriptions.keys) {
      var ids = _subscriptions[reqType].toList(growable: false);
      if (ids.isEmpty) continue;
      var args = {};

      var cmd = '';
      switch (reqType) {
        case ZabbixTrigger.isType:
          cmd = RequestMethod.triggerGet;
          args = {
            'triggerids' : ids,
            'expandComment' :  true,
            'expandDescription' : true,
            'expandExpression' : true,
            'selectFunctions' : 'expand'
          };
          break;
        case ZabbixItem.isType:
          cmd = RequestMethod.itemGet;
          args = { 'itemids' : ids };
          break;
        default:
          cmd = null;
          break;
      }
      if (cmd == null) continue;
      _client.makeRequest(cmd, args).then((result) {
        if (result.containsKey('error')) {
          logger.warning('Error updating nodes: ${result['error']}');
          return;
        }

        for (var tmp in result['result']) {
          ZabbixChild nd;
          var tmpId = '';
          switch (reqType) {
            case ZabbixTrigger.isType:
              tmpId = tmp['triggerid'];
              nd = ZabbixTrigger.getById(tmpId);
              break;
            case ZabbixItem.isType:
              tmpId = tmp['itemid'];
              nd = ZabbixItem.getById(tmpId);
              break;
          }

          if (nd == null) {
            logger.warning('Unable to find: $tmpId of type: $reqType');
            continue;
          }
          nd.update(tmp);
        }
      });
    }
  }

}
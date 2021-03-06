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

//* @Node
//* @MetaType ZabbixNode
//* @Is zabbixNode
//* @Parent root
//*
//* Main connection to the remote Zabbix server.
//*
//* Zabbix node manages the client which connects to the remote Zabbix server.
//* This node also manages the subscriptions to child nodes to ensure that
//* update polls are minimal and efficient.
class ZabbixNode extends SimpleNode {
  static const String isType = 'zabbixNode';
  static Map<String, dynamic> definition(Map params) => {
    r'$is' : isType,
    r'$$zb_addr' : params['address'],
    r'$$zb_user' : params['username'],
    r'$$zb_pass' : params['password'],
    r'$$zb_refresh' : params['refreshRate'],
    //* @Node HostGroups
    //* @Parent ZabbixNode
    //*
    //* Container for the various host groups.
    'HostGroups' : {
      CreateHostGroup.pathName : CreateHostGroup.definition()
    },
    EditConnection.pathName : EditConnection.definition(params),
    RemoveConnection.pathName : RemoveConnection.definition(),
    RefreshConnection.pathName: RefreshConnection.definition()
  };

  ZabbixNode(String path, this._link) : super(path) {
    _clientComp = new Completer<ZabbixClient>();
    _subscriptions = new HashMap<String, HashMap<String, Set>>();
    _pendingRequests = new Set<String>();
  }

  Future<ZabbixClient> get client => _clientComp.future;
  ZabbixNode get rootParent => this;

  ZabbixClient _client;
  int _refreshRate;
  Completer<ZabbixClient> _clientComp;
  LinkProvider _link;
  HashMap<String, HashMap<String, Set>> _subscriptions;
  Timer _refreshTimer;
  Set<String> _pendingRequests;

  @override
  void onCreated() {
    var refresh = provider.getNode('$path/${RefreshConnection.pathName}');
    if (refresh == null) {
      provider.addNode('$path/${RefreshConnection.pathName}',
          RefreshConnection.definition());
      _link.save();
    }

    var username = getConfig(r'$$zb_user');
    var password = getConfig(r'$$zb_pass');
    var address = getConfig(r'$$zb_addr');
    _refreshRate = getConfig(r'$$zb_refresh');

    _client = new ZabbixClient(address, username, password);

    _client.authenticate().then((_) {
      _clientComp.complete(_client);
      var params = {'selectHosts' : 'extend'};
      _client.makeRequest(RequestMethod.hostgroupGet, params).then(updateHosts);
    });

    var dur = new Duration(milliseconds: _refreshRate * 1000);
    _refreshTimer = new Timer.periodic(dur, _refreshCallback);
  }

  @override
  void onRemoving() {
    _client.close();
  }

  String updateHosts(Map<String, dynamic> hostGroups) {
    var hostIds = [];

    if (hostGroups.containsKey('error')) {
      logger.warning('Error polling hostgroups: ${hostGroups['error']}');
      return hostGroups['error'];
    }
    var groupList = hostGroups['result'] as List;
    var hgPath = provider.getOrCreateNode('$path/HostGroups');
    for (var nd in hgPath.children.keys.toList(growable: false)) {
      provider.removeNode('${hgPath.path}/$nd');
    }

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

    return null;
  }

  void updateConfig(Map params, ZabbixClient newClient) {
    configs[r'$$zb_user'] = params['username'].trim();
    configs[r'$$zb_pass'] = params['password'];
    configs[r'$$zb_addr'] = params['address'];
    configs[r'$$zb_refresh'] = params['refreshRate'];

    if (_refreshRate != params['refreshRate']) {
      if (_refreshTimer != null && _refreshTimer.isActive) {
        _refreshTimer.cancel();
      }
      _refreshRate = params['refreshRate'];
      _refreshTimer = new Timer.periodic(
          new Duration(milliseconds: _refreshRate * 1000),
          _refreshCallback);
    }

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

  void addSubscription(String parId, String type, String valueName) {
    HashMap typeMap = _subscriptions.putIfAbsent(type, () => new HashMap<String, Set>());
    Set items = typeMap.putIfAbsent(parId, () => new Set());
    items.add(valueName);
  }

  void removeSubscription(String parId, String type, String valueName) {
    HashMap typeMap = _subscriptions[type];
    if (typeMap == null) return;
    Set items = typeMap[parId];
    if (items == null) return;
    items.remove(valueName);

    if (items.isEmpty) {
      typeMap.remove(parId);
    }

    if (typeMap.keys.isEmpty) {
      _subscriptions.remove(type);
    }
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
        //* @Node Alerts
        //* @Parent ZabbixEvent
        //*
        //* Container of alerts generated by the ZabbixEvent
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
      //* @Node Items
      //* @Parent ZabbixHost
      //*
      //* Collection of items for the given ZabbixHost.
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
      //* @Node Triggers
      //* @Parent ZabbixHost
      //*
      //* Container node for the ZabbixTriggers
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
          //* @Node Events
          //* @Parent ZabbixTrigger
          //*
          //* Container node for ZabbixEvent's on a Trigger.
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
    for (var reqType in _subscriptions.keys) {
      if (_pendingRequests.contains(reqType)) continue;

      var ids = _subscriptions[reqType].keys.toList(growable: false);
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
        case ZabbixEvent.isType:
          cmd = RequestMethod.eventGet;
          args = {
            'eventids' : ids,
            'select_acknowledges' : 'extend',
          };
          break;
        case ZabbixHost.isType:
          cmd = RequestMethod.hostGet;
          args = {
            'hostids' : ids,
          };
          break;
        default:
          cmd = null;
          break;
      }
      if (cmd == null) continue;

      _pendingRequests.add(reqType);
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
            case ZabbixEvent.isType:
              tmpId = tmp['eventid'];
              nd = ZabbixEvent.getById(tmpId);
              break;
            case ZabbixHost.isType:
              tmpId = tmp['hostid'];
              nd = ZabbixHost.getById(tmpId);
              break;
          }

          if (nd == null) {
            logger.warning('Unable to find: $tmpId of type: $reqType');
            continue;
          }
          nd.update(tmp);
        }
        _pendingRequests.remove(reqType);
      });
    }
  }
}

//* @Action Refresh_Hosts
//* @Is connectionRefresh
//* @Parent ZabbixNode
//*
//* Refreshes the host list.
//*
//* Refresh Hosts will poll the remote zabbix server and update the hosts
//* with any new host groups, hosts or update configurations of the above.
//*
//* @Return value
//* @Column success bool Success returns true when the action is successful;
//* return false on failure.
//* @Column message string Message returns Success! when action is successful;
//* returns an error message on failure.
class RefreshConnection extends SimpleNode {
  static const String isType = 'connectionRefresh';
  static const String pathName = 'Refresh_Hosts';

  static const String _success = 'success';
  static const String _message = 'message';

  static Map<String, dynamic> definition() => {
    r'$is': isType,
    r'$name': 'Refresh Hosts',
    r'$invokable': 'write',
    r'$params': [],
    r'$columns': [
      { 'name': _success, 'type': 'bool', 'default': false },
      { 'name': _message, 'type': 'string', 'default': '' }
    ]
  };

  RefreshConnection(String path) : super(path);

  @override
  Future<Map<String, dynamic>> onInvoke(Map<String, dynamic> params) async {
    final ret = { _success: false, _message : '' };

    var params = {'selectHosts' : 'extend'};
    var cl = await (parent as ZabbixNode).client;

    var groups = await cl.makeRequest(RequestMethod.hostgroupGet, params);
    var result = (parent as ZabbixNode).updateHosts(groups);

    ret[_success] = (result == null);
    if (ret[_success]) {
      ret[_message] = 'Success!';
    } else {
      ret[_message] = 'Unable to update hosts: $result';
    }

    return ret;
  }
}

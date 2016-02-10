library dslink.zabbix.nodes.zabbix_event;

import 'dart:async';
import 'dart:collection' show HashMap;

import 'package:dslink/dslink.dart';
import 'package:dslink/utils.dart';

import 'client.dart';
import 'common.dart';

class ZabbixEvent extends ZabbixChild {
  static const String isType = 'zabbixEventNode';

  static final HashMap<String, ZabbixEvent> _cache =
  new HashMap<String, ZabbixEvent>();

  static ZabbixEvent getById(String id) => _cache[id];

  static const _values = const {
    '0' : const { '0' : 'Ok', '1' : 'Problem'},
    '1' : const {
      '0' : 'host or service up',
      '1' : 'host or service down',
      '2' : 'host or service discovered',
      '3' : 'host or service lost'
    },
    '3' : const { '0' : 'normal', '1' : 'Unknown or Not Supported'}
  };
  static const _objects = const {
    '0' : const { '0' : 'Trigger'},
    '1' : const { '1' : 'discovered host', '2' : 'discovered service'},
    '2' : const { '3' : 'auto-registered host'},
    '3' : const { '0' : 'Trigger', '4' : 'Item', '5' : 'LLD rule'}
  };
  static const _sources = const [
    'trigger', 'discovery rule', 'auto-registration', 'internal'];

  static Map<String, dynamic> _acknowledgementDefinition(Map ack) {
    var ackTime = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(ack['clock']) * 1000);

    return {
      'userid' : {
        r'$name' : 'User ID',
        r'$type' : 'string',
        r'?value' : ack['userid'],
        'alias' : ZabbixValue.definition('Alias', 'string', ack['alias'],
            false),
        'name' : ZabbixValue.definition('Name', 'string', ack['name'], false),
        'surname' : ZabbixValue.definition('Surname', 'string',
            ack['surname'], false)
      },
      'clock' : ZabbixValue.definition('Acknowledged Time', 'string',
          ackTime.toIso8601String(), false),
      'message' : ZabbixValue.definition('Message', 'string', ack['message'],
          false)
    };
  }

  static Map<String, dynamic> definition(Map event) {
    var source = _sources[int.parse(event['source'])];
    var time = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(event['clock']) * 1000);
    var relatedObject = _objects[event['source']][event['object']];
    var eventValue = _values[event['source']][event['value']];

    var acknowledgements = {};
    for (Map ack in event['acknowledges']) {
      acknowledgements[ack['acknowledgeid']] = _acknowledgementDefinition(ack);
    }

    var ret = {
      r'$is' : isType,
      'eventid' : ZabbixValue.definition('Event ID', 'string', event['eventid'],
          false),
      'acknowledged' : {
        r'$name' : 'Acknowledged',
        r'$type' : 'number',
        r'?value' : int.parse(event['acknowledged']),
        'Acknowledgements' : acknowledgements
      },
      'clock' : ZabbixValue.definition(
          'Created', 'string', time.toIso8601String(),
          false),
      'ns' : ZabbixValue.definition('Created (nanoseconds)', 'string',
          event['ns'], false),
      'object' : ZabbixValue.definition('Object type', 'string', relatedObject,
          false),
      'objectid' : ZabbixValue.definition('Object ID', 'string',
          event['objectid'], false),
      'source' : ZabbixValue.definition('Type', 'string', source, false),
      'value' : ZabbixValue.definition('Value', 'string', eventValue, false),
      AcknowledgeEvent.pathName : AcknowledgeEvent.definition()
    };

    if (event['value_changed'] != null) {
      ret['value_changed'] = ZabbixValue.definition('Value Changed', 'number',
          event['value_changed'], false);
    }
    return ret;
  }

  ZabbixEvent(String path) : super(path);

  @override
  void onCreated() {
    _cache.putIfAbsent(name, () => this);
  }

  bool updateChild(String path, String valueName, newValue, oldValue) => true;

  void update(Map updatedValues) {
    updateAcknowledges(List<Map> acks) {
      var acksNd = provider.getOrCreateNode('$path/acknowledged/Acknowledgements');

      for (Map ack in acks) {
        var aNode = provider.getNode('${acksNd.path}/${ack['acknowledgeid']}');
        if (aNode == null) {
          provider.addNode('${acksNd.path}/${ack['acknowledgeid']}',
              _acknowledgementDefinition(ack));
          continue;
        }

        var ackTime = new DateTime.fromMillisecondsSinceEpoch(
            int.parse(ack['clock']) * 1000);
        for (var key in ack.keys) {
          LocalNode nd;
          var newVal;
          switch (key) {
            case 'alias':
            case 'name':
            case 'surname':
              nd = provider.getNode('${aNode.path}/userid/$key');
              newVal = ack[key];
              break;
            case 'clock':
              newVal = ackTime.toIso8601String();
              break;
            default:
              nd = provider.getNode('${aNode.path}/$key');
              newVal = ack[key];
          }

          nd.updateValue(newVal);
        }
      }
    }

    var source = _sources[int.parse(updatedValues['source'])];
    var clock = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(updatedValues['clock']) * 1000);
    var relatedObject = _objects[updatedValues['source']][updatedValues['object']];
    var eventValue = _values[updatedValues['source']][updatedValues['value']];

    for (var key in updatedValues.keys) {
      var nd = provider.getNode('$path/$key');
      var newVal;
      switch (key) {
        case 'acknowledges':
          updateAcknowledges(updatedValues[key]);
          continue;
        case 'clock':
          newVal = clock.toIso8601String();
          break;
        case 'object':
          newVal = relatedObject;
          break;
        case 'source':
          newVal = source;
          break;
        case 'value':
          newVal = eventValue;
          break;
        default:
          newVal = updatedValues[key];
      }

      if (nd == null && key == 'value_changed') {
        provider.addNode('$path/$key', ZabbixValue.definition('Value Changed',
            'number', num.parse(updatedValues[key]), false));
      }
      nd?.updateValue(newVal);
    }
  }
}

class AcknowledgeEvent extends SimpleNode {
  static const String isType = 'zabbixAcknowledgeEvent';
  static const String pathName = 'Acknowledge_Event';
  static Map<String, dynamic> definition() => {
    r'$is' : isType,
    r'$name' : 'Acknowledge Event',
    r'$invokable' : 'write',
    r'$params' : [
      {
        'name' : 'message',
        'type' : 'string',
        'placeholder' : 'Acknowledgement Message'
      }
    ],
    r'$columns' : [
      {
        'name' : 'success',
        'type' : 'bool',
        'default' : false
      },
      {
        'name' : 'resultMessage',
        'type' : 'string',
        'default': ''
      }
    ]
  };

  AcknowledgeEvent(String path) : super(path);

  @override
  Future<Map<String, dynamic>> onInvoke(Map<String, dynamic> params) async {
    var ret = { 'success' : false, 'resultMessage' : '' };
    if (params['message'] == null || params['message'].trim().isEmpty) {
      ret['resultMessage'] = 'AcknowledgementMessage is required.';
      return ret;
    }

    var p = parent as ZabbixEvent;
    var client = await p.client;
    var args = {
      'eventids' : p.name,
      'message' : params['message']
    };

    var result = await client.makeRequest(RequestMethod.eventAcknowledge, args);
    if (result.containsKey('error')) {
      logger.warning('Error deleting Hostgroup: ${result['error']}');
      ret['resultMessage'] = result['error']['data'];
    } else {
      ret['success'] = true;
      ret['resultMessage'] = 'Success';
    }

    return ret;
  }
}
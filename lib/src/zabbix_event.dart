library dslink.zabbix.nodes.zabbix_event;

import 'dart:async';

import 'package:dslink/dslink.dart';
import 'package:dslink/utils.dart';

import 'client.dart';
import 'common.dart';

class ZabbixEvent extends ZabbixChild {
  static const String isType = 'zabbixEventNode';
  static Map<String, dynamic> definition(Map event) {
    final sources = ['trigger', 'discovery rule', 'auto-registration', 'internal'];
    var source = sources[int.parse(event['sources'])];

    final objects = {
      '0' : { '0' : 'Trigger'},
      '1' : { '1' : 'discovered host', '2' : 'discovered service' },
      '2' : { '3' : 'auto-registered host' },
      '3' : { '0' : 'Trigger', '4' : 'Item', '5' : 'LLD rule' }
    };
    var relatedObject = objects[event['source']][event['object']];

    final values = {
      '0' : { '0' : 'Ok', '1' : 'Problem' },
      '1' : {
        '0' : 'host or service up',
        '1' : 'host or service down',
        '2' : 'host or service discovered',
        '3' : 'host or service lost'
      },
      '3' : { '0' : 'normal', '1' : 'Unknown or Not Supported' }
    };
    var eventValue = values[event['source']][event['value']];

    return {
      r'$is' : isType,
      'eventid' : ZabbixValue.definition('Event ID', 'string', event['eventid'],
          false),
      'acknowledged' : ZabbixValue.definition('Acknowledged', 'number',
          event['acknowledged'], false),
      'clock' : ZabbixValue.definition('Created', 'string', event['clock'],
          false),
      'ns' : ZabbixValue.definition('Created (nanoseconds)', 'string',
          event['ns'], false),
      'object' : ZabbixValue.definition('Object type', 'string', relatedObject,
          false),
      'objectid' : ZabbixValue.definition('Object ID', 'string',
          event['objectid'], false),
      'source' : ZabbixValue.definition('Type', 'string', source, false),
      'value' : ZabbixValue.definition('Value', 'string', eventValue, false),
      'value_changed' : ZabbixValue.definition('Value Changed', 'number',
          event['value_changed'], false),
      AcknowledgeEvent.pathName : AcknowledgeEvent.definition()
    };
  }

  ZabbixEvent(String path) : super(path);
  bool updateChild(String path, String valueName, newValue, oldValue) => true;
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
library dslink.zabbix.nodes.zabbix_alert;

import 'common.dart';

class ZabbixAlert extends ZabbixChild {
  static const isType = 'zabbixAlertNode';

  static Map<String, dynamic> definition(Map alert) {
    final alertStatus = {
      '0' : {
        'type' : 'message',
        'status' : {
          '0' : 'message not sent',
          '1' : 'message sent',
          '2' : 'failed after a number of retries'
        }
      },
      '1' : {
        'type' : 'remote command',
        'status' : {
          '1' : 'command run',
          '2' : 'Tried but Zabbix agent unavailable.'
        }
      }
    };

    var alertType = alertStatus[alert['alerttype']]['type'];
    var status = alertStatus[alert['alerttype']]['status'][alert['status']];

    return {
      r'$is' : isType,
      'actionid' : ZabbixValue.definition('Action ID', 'string',
          alert['actionid'], false),
      'alerttype' : ZabbixValue.definition('Alert Type', 'string', alertType, false),
      'clock' : ZabbixValue.definition('Clock', 'string', alert['clock'], false),
      'error' : ZabbixValue.definition('Error', 'string', alert['error'], false),
      'esc_step' : ZabbixValue.definition('Escalation Step', 'number',
          int.parse(alert['esc_step']), false),
      'eventid' : ZabbixValue.definition('Event ID', 'string', alert['eventid'], false),
      'mediatypeid' : ZabbixValue.definition('Media Type id', 'string',
          alert['mediatypeid'], false),
      'message' : ZabbixValue.definition('Message', 'string', alert['message'], false),
      'retries' : ZabbixValue.definition('Retries', 'number',
          int.parse(alert['retries']), false),
      'sendto' : ZabbixValue.definition('Recipient', 'string', alert['sendto'], false),
      'status' : ZabbixValue.definition('Status', 'string', status, false),
      'subject' : ZabbixValue.definition('Subject', 'string', alert['subject'], false),
      'userid' : ZabbixValue.definition('User Id', 'string', alert['userid'], false)
    };
  }

  ZabbixAlert(String path) : super(path);

  bool updateChild(String path, String valueName, newValue, oldValue) => true;
}
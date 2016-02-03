library dslink.zabbix.client;

import 'dart:async';
import 'dart:collection' show Queue, HashMap;
import 'dart:convert' show JSON, UTF8;
import 'dart:io';

import 'package:dslink/utils.dart' show logger;

abstract class RequestMethod {
  static const String userLogin = 'user.login';
  static const String hostGet = 'host.get';
}


class ZabbixClient {
  static const maxRequests = 5;
  static final Map<String, ZabbixClient> _cache = <String, ZabbixClient>{};
  static const Map defaultBody = const {
    'jsonrpc' : '2.0',
    'method' : '',
    'params' : const {},
    'id' : 0,
    'auth': null
  };

  factory ZabbixClient(String uri, String user, String pass) {
    var cache = _cache[uri];
    if (cache == null) {
      return _cache[uri] = new ZabbixClient._(uri, user, pass);
    }

    if (cache.authenticated) return cache;
    if (cache.uri == uri && cache._username == user && cache._password == pass) {
      return cache;
    } else {
      return _cache[uri] = new ZabbixClient._(uri, user, pass);
    }
  }

  ZabbixClient._(this.uri, String user, String pass) {
    _username = user;
    _password = pass;

    var url = uri;
    if (!url.endsWith('api_jsonrpc.php')) {
      if  (!url.endsWith('/')) {
        url += '/';
      }
      url += 'api_jsonrpc.php';
    }
    _uri = Uri.parse(url);
    _pending = new Queue<PendingRequest>();
    _client = new HttpClient();
  }

  bool authenticated = false;
  bool requestPending = false;
  bool expired = false;
  String uri;

  String _username;
  String _password;
  String _auth;
  Uri _uri;
  HttpClient _client;
  int _requestId = 0;
  Queue<PendingRequest> _pending;

  Future<Map> authenticate() async {
    var ret = {'success' : false};
    if (authenticated && _auth != null) {
      ret['success'] = true;
      return ret;
    }

    var params = { 'user': _username, 'password' : _password };
    var req = new PendingRequest(RequestMethod.userLogin, params, ++_requestId);
    req.isAuthentication = true;

    var res;
    try {
      res = await sendRequest(req);
    } on HttpException {
      ret['error'] = 'Error querying server';
    } on FormatException  {
      ret['error'] = 'Error parsing results';
    } catch (e) {
      ret['error'] = 'Unknown error';
    }

    if (res.containsKey('result')) {
      _auth = res['result'];
      authenticated = true;
      ret['success'] = true;
    } else {
      ret['error'] = res['error']['data'];
    }
    return ret;
  }

  Future<Map> makeRequest(String requestMethod, Map params) {
    if (params == null) {
      params = {'output' : 'extend'};
    } else {
      params['output'] ??= 'extend';
    }
    var pr = new PendingRequest(requestMethod, params, ++_requestId);
    return sendRequest(pr);
  }

  Future<Map> sendRequest(PendingRequest request) {
    if (!authenticated && request.isAuthentication) {
      _pending.addFirst(request);
    } else {
      _pending.add(request);
    }
    _sendRequests();
    return request.done;
  }

  Future _sendRequests() async {
    if (requestPending || _pending.isEmpty) return;

    requestPending = true;
    PendingRequest preq;
    HashMap<int, PendingRequest> requests = new HashMap<int, PendingRequest>();
    var body;
    var batch = false;

    if (!authenticated) {
      if (!_pending.first.isAuthentication) {
        authenticate();
        requestPending = false;
        _sendRequests();
        return;
      }
      preq = _pending.removeFirst();
      body = new Map.from(defaultBody);
      body['method'] = preq.method;
      body['params'] = preq.params;
      body['id'] = preq.id;
    } else {
      if (_pending.length > 1) {
        body = new List<Map>();
        batch = true;
        var len = (_pending.length > maxRequests ? maxRequests : _pending.length);
        for (var i = 0; i < len; i++) {
          var req = _pending.removeFirst();
          var tmpBody = new Map.from(defaultBody);
          tmpBody['method'] = req.method;
          tmpBody['params'] = req.params;
          tmpBody['id'] = req.id;
          tmpBody['auth'] = _auth;
          body.add(tmpBody);
          requests[req.id] = req;
        }
      } else {
        preq = _pending.removeFirst();
        body = new Map.from(defaultBody);
        body['method'] = preq.method;
        body['params'] = preq.params;
        body['id'] = preq.id;
        body['auth'] = _auth;
      }
    }

    var allResults;
    try {
      var bodyStr = JSON.encode(body);
      logger.finest('Requests: $bodyStr');
      var req = await _client.postUrl(_uri);
      req.headers.contentType =
          ContentType.parse('application/json-rpc; charset=utf-8');
      req.write(bodyStr);
      var resp = await req.close();
      var resultStr = await resp.transform(UTF8.decoder).join();
      allResults = JSON.decode(resultStr);
      logger.finest('All Results: $allResults');
    } on HttpException catch(e) {
      logger.warning('Unable to connect to server: $_uri', e);
      if (!batch) {
        preq._completer.completeError(e);
      } else {
        for (var r in requests.values) {
          r._completer.completeError(e);
        }
      }
    } catch (e) {
      logger.warning('Failed to handle request to: $_uri', e);
      if (!batch) {
        preq._completer.completeError(e);
      } else {
        for (var r in requests.values) {
          r._completer.completeError(e);
        }
      }
    }

    if (!batch) {
      if (allResults['id'] != preq.id) {
        logger.warning('Response ID: ${allResults['id']} '
            'does not match request id: ${preq.id}');
        preq._completer.completeError(allResults['id']);
      } else {
        if (allResults.containsKey('error')) {
          preq._completer.complete({'error' : allResults['error']});
        } else {
          preq._completer.complete({'result' : allResults['result']});
        }
      }
    } else {
      for (Map res in allResults) {
        var resId = res['id'];
        var req = (resId != null ? requests.remove(resId) : null);
        if (res.containsKey('error')) {
          logger.warning('Error response: $res');
          if (req != null) {
            req._completer.complete({'error' : res['error']});
          }
        } else {
          if (req != null) {
            req._completer.complete({'result' : res['result']});
          }
        }
      }
      if (requests.keys.isNotEmpty) {
        logger.warning('Missing results for requests: ${requests.keys}');
        requests.values.forEach((pr) => pr._completer.completeError('No result'));
      }
      requests.clear();
    }

    requestPending = false;
    _sendRequests();
  }

  void close() {
    _client.close(force: true);
    if (_pending.isNotEmpty) {
      _pending.forEach((pr) {
        pr._completer.complete(null);
      });
      _pending.clear();
    }
    expired = true;
    _cache.remove(uri);
  }

}

class PendingRequest {
  int id;
  String method;
  Map params;
  bool isAuthentication = false;

  Completer<Map> _completer;
  Future<Map> get done => _completer.future;

  PendingRequest(this.method, this.params, this.id) {
    _completer = new Completer();
  }
}
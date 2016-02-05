library dslink.zabbix.client;

import 'dart:async';
import 'dart:collection' show Queue, HashMap;
import 'dart:convert' show JSON, UTF8;
import 'dart:io';

import 'package:dslink/utils.dart' show logger;

abstract class RequestMethod {
  static const String hostGet = 'host.get';
  static const String hostUpdate = 'host.update';

  static const String userLogin = 'user.login';

  static const String itemGet = 'item.get';
  static const String itemUpdate = 'item.update';
}


class ZabbixClient {
  static const maxRequests = 3;
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
  int requestsPending = 0;
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
    if (requestsPending >= maxRequests || _pending.isEmpty) return;

    requestsPending += 1;
    PendingRequest preq;
    var body;

    if (!authenticated) {
      if (!_pending.first.isAuthentication) {
        authenticate();
        requestsPending -= 1;
        _sendRequests();
        return;
      }
      preq = _pending.removeFirst();
      body = new Map.from(defaultBody);
      body['method'] = preq.method;
      body['params'] = preq.params;
      body['id'] = preq.id;
    } else {
      preq = _pending.removeFirst();
      body = new Map.from(defaultBody);
      body['method'] = preq.method;
      body['params'] = preq.params;
      body['id'] = preq.id;
      body['auth'] = _auth;
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
      preq._completer.completeError(e);
    } catch (e) {
      logger.warning('Failed to handle request to: $_uri', e);
      preq._completer.completeError(e);
    }

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

    requestsPending -= 1;
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
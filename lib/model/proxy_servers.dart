//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/12
//
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Proxy {
  final String id = Uuid().toString();
  final String host;
  final String port;
  final String? username;
  final String? password;

  Proxy({required this.host, required this.port, this.username, this.password});
}

class ProxyServers with ChangeNotifier {
  List<Proxy> proxies = [];

  String? currentId;

  void addProxy(Proxy proxy) {
    proxies.add(proxy);
    notifyListeners();
  }

  Proxy? getCurrentProxy() {
    return proxies.firstWhereOrNull((element) => element.id == currentId);
  }
}

//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/12
//
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Proxy {
  final String id;
  final String label;
  final String protocol;
  final String host;
  final String port;
  final String? username;
  final String? password;

  Proxy({
    required this.id,
    this.label = "",
    required this.protocol,
    required this.host,
    required this.port,
    this.username,
    this.password,
  });

  String getName() {
    if (label.isNotEmpty) {
      return label;
    } else {
      var tokens = host.split(".");
      return tokens.last;
    }
  }
}

class ProxyItem extends Proxy {
  bool isCurrent;

  ProxyItem(
      {required super.id,
      required super.protocol,
      required super.host,
      required super.port,
      required this.isCurrent});

  factory ProxyItem.fromProxy(bool isCurrent, Proxy proxy) {
    return ProxyItem(
        id: proxy.id, protocol: proxy.protocol, host: proxy.host, port: proxy.port, isCurrent: isCurrent);
  }
}

class ProxyServers with ChangeNotifier {
  List<Proxy> proxies = [
    Proxy(id: "1", protocol: "socks", host: "192.168.0.118", port: "7890"),
    Proxy(id: "2", protocol: "socks", host: "192.168.0.105", port: "7890"),
  ];

  String? currentId = "1";

  void addProxy(Proxy proxy) {
    proxies.add(proxy);
    notifyListeners();
  }

  List<ProxyItem> getProxyList() {
    return proxies.map((e) => ProxyItem.fromProxy(currentId == e.id, e)).toList();
  }

  Proxy? getCurrentProxy() {
    return proxies.firstWhereOrNull((element) => element.id == currentId);
  }
}

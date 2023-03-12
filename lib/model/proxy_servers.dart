//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/12
//
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Proxy {
  final String id;
  final String label;
  final String protocol;
  final String host;
  final int port;
  final String? username;
  final String? password;

  Proxy({
    required this.id,
    required this.protocol,
    required this.host,
    required this.port,
    this.username,
    this.password,
    this.label = "",
  });

  Proxy copyWith({
    String? id,
    String? protocol,
    String? host,
    int? port,
    String? username,
    String? password,
    String? label,
  }) {
    return Proxy(
      id: id ?? this.id,
      protocol: protocol ?? this.protocol,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      label: label ?? this.label,
    );
  }

  factory Proxy.fromJson(dynamic json) {
    return Proxy(
      id: json['id'],
      protocol: json['protocol'],
      host: json['host'],
      port: json['port'],
      username: json['username'],
      password: json['password'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['protocol'] = protocol;
    map['host'] = host;
    map['port'] = port;
    map['username'] = username;
    map['password'] = password;
    map['label'] = label;
    return map;
  }

  String getName() {
    if (label.isNotEmpty) {
      return label;
    } else {
      var tokens = host.split(".");
      return tokens.last;
    }
  }

  String toProxyUrl() {
    if (username?.isNotEmpty ?? false) {
      return "$protocol://$username:$password@$host:$port";
    }
    return "$protocol://$host:$port";
  }
}

class ProxyItem extends Proxy {
  bool isCurrent;

  ProxyItem({
    required super.id,
    required super.protocol,
    required super.host,
    required super.port,
    super.username,
    super.password,
    super.label,
    required this.isCurrent,
  });

  factory ProxyItem.fromProxy(bool isCurrent, Proxy proxy) {
    return ProxyItem(
      id: proxy.id,
      protocol: proxy.protocol,
      host: proxy.host,
      port: proxy.port,
      username: proxy.username,
      password: proxy.password,
      label: proxy.label,
      isCurrent: isCurrent,
    );
  }
}

const String proxiesKey = "proxies";
const String currentIdKey = "currentId";

class ProxyServers with ChangeNotifier {
  List<Proxy> proxies = [];

  String? currentId;

  Future<void> initialize() async {
    proxies = await getProxiesFromStorage();
    currentId = await getCurrentIdFromStorage();
    notifyListeners();
  }

  Future<List<Proxy>> getProxiesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final valList = prefs.getStringList(proxiesKey);
    if (valList != null) {
      return valList.map((e) => Proxy.fromJson(jsonDecode(e))).toList();
    }
    return [];
  }

  Future<String?> getCurrentIdFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentIdKey);
  }

  Future<void> saveProxiesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(proxiesKey, proxies.map((e) => jsonEncode(e.toJson())).toList());
  }

  Future<void> saveCurrentIdToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (currentId != null) {
      prefs.setString(currentIdKey, currentId!);
    } else {
      prefs.remove(currentIdKey);
    }
  }

  void addProxy({required String host, required int port, username, password}) {
    final id = Uuid().v4();
    if (proxies.isEmpty) {
      setCurrent(id);
    }
    proxies.add(Proxy(
      protocol: "socks",
      id: id,
      host: host,
      port: port,
      username: username,
      password: password,
    ));
    saveProxiesToStorage().then((_) => notifyListeners());
  }

  void deleteProxy(String id) {
    proxies = proxies.whereNotIndexed((index, element) => element.id == id).toList();
    saveProxiesToStorage().then((_) => notifyListeners());
  }

  void updateProxy(Proxy proxy) {
    final index = proxies.indexWhere((element) => element.id == proxy.id);
    proxies[index] = proxy;
    saveProxiesToStorage().then((_) => notifyListeners());
  }

  void setCurrent(String id) {
    currentId = id;
    saveCurrentIdToStorage().then((value) => notifyListeners());
  }

  List<ProxyItem> getProxyList() {
    print('currentId: $currentId');
    print('proxies: $proxies');
    return proxies.map((e) => ProxyItem.fromProxy(currentId == e.id, e)).toList();
  }

  Proxy? getCurrentProxy() {
    return proxies.firstWhereOrNull((element) => element.id == currentId);
  }
}

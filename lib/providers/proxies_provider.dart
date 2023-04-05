//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:leaves/hive/hive_boxes.dart';
import 'package:leaves/model/proxy.dart';
import 'package:uuid/uuid.dart';

class ProxiesProvider with ChangeNotifier {
  List<Proxy> proxyList = [];

  String? currentId;

  Future<void> initialize() async {
    proxyList = ProxiesHive.getProxyList();
    currentId = ProxiesHive.getCurrentId();
    notifyListeners();
  }

  //设置当前代理ID
  void setCurrentId(String id) {
    currentId = id;
    ProxiesHive.setCurrentId(id);
    notifyListeners();
  }

  //获取代理列表
  List<Proxy> getProxyList() {
    return proxyList.map((e) {
      if (e.id == currentId) {
        return e.copyWith(isCurrent: true);
      } else {
        return e.copyWith(isCurrent: false);
      }
    }).toList();
  }

  //获取当前代理
  Proxy? getCurrentProxy() {
    if (currentId == null) {
      return null;
    }
    return proxyList.firstWhereOrNull((element) => element.id == currentId);
  }

  //添加新代理
  Proxy addProxy({required String host, required int port, username, password}) {
    final id = Uuid().v4();
    if (proxyList.isEmpty) {
      setCurrentId(id);
    }
    final proxy = Proxy(
      scheme: "socks",
      id: id,
      host: host,
      port: port,
      username: username,
      password: password,
    );
    proxyList.add(proxy);
    ProxiesHive.setProxyList(proxyList);
    notifyListeners();
    return proxy;
  }

  //删除代理
  void deleteProxy(String id) {
    proxyList = proxyList.whereNotIndexed((index, element) => element.id == id).toList();
    ProxiesHive.setProxyList(proxyList);
    notifyListeners();
  }

  //更新代理
  void updateProxy(Proxy proxy) {
    final index = proxyList.indexWhere((element) => element.id == proxy.id);
    proxyList[index] = proxy;
    ProxiesHive.setProxyList(proxyList);
    notifyListeners();
  }
}

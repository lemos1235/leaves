//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:leaves/model/proxy.dart';

import '../hive_boxes.dart';

class ProxiesHive {
  const ProxiesHive._();

  static const String _keyProxyList = 'proxyList';
  static const String _keyCurrentId = 'currentId';

  //获取当前激活的代理ID
  static String? getCurrentId() {
    final box = Hive.box(HiveBoxes.proxiesBox);
    return box.get(_keyCurrentId);
  }

  //设置当前激活的代理ID
  static void setCurrentId(String e) {
    final box = Hive.box(HiveBoxes.proxiesBox);
    box.put(_keyCurrentId, e);
  }

  //获取代理列表
  static List<Proxy> getProxyList() {
    final box = Hive.box(HiveBoxes.proxiesBox);
    final data = box.get(_keyProxyList);
    if (data == null) {
      return [];
    }
    List<String> proxyStrList = (data as List).cast<String>();
    return proxyStrList.map((e) => Proxy.fromJson(jsonDecode(e))).toList();
  }

  //设置代理列表
  static void setProxyList(List<Proxy> proxyList) {
    final box = Hive.box(HiveBoxes.proxiesBox);
    final proxyStrList = proxyList.map((e) => jsonEncode(e.toJson())).toList();
    box.put(_keyProxyList, proxyStrList);
  }
}

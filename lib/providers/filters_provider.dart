//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:leaves/constant/filter_mode.dart';
import 'package:leaves/hive/modules/filters_hive.dart';
import 'package:leaves/hive/modules/proxies_hive.dart';
import 'package:leaves/model/filter_app.dart';
import 'package:leaves/model/proxy.dart';
import 'package:leaves/pages/setting/filters/filters_page.dart';
import 'package:uuid/uuid.dart';

class FiltersProvider with ChangeNotifier {
  List<FilterApp> filterAppList = [];

  List<String> internalPackageNames = [
    'club.lemos.leaves',
    'com.github.kr328.clash',
    'com.github.shadowsocks',
    'com.leaf.and.aleaf',
  ];

  FilterMode currentMode = FilterMode.off;

  Future<void> initialize() async {
    filterAppList = FiltersHive.getFilterAppList();
    currentMode = FiltersHive.getCurrentMode();
    notifyListeners();
  }

  //获取内置应用
  List<String> getInternalPackageNames() {
    return internalPackageNames;
  }

  //获取当前模式
  FilterMode getFilterMode() {
    return currentMode;
  }

  //设置当前模式
  void setFilterMode(FilterMode mode) {
    currentMode = mode;
    FiltersHive.setCurrentMode(mode);
    notifyListeners();
  }

  //获取应用列表
  String getFilterPackageNames() {
    return filterAppList.map((e) => e.packageName).join(",");
  }

  //获取应用列表
  List<FilterApp> getFilterAppList() {
    return filterAppList;
  }

  //更新应用列表
  void setFilterAppList(List<FilterApp> appList) {
    filterAppList = appList;
    FiltersHive.setFilterAppList(appList);
    notifyListeners();
  }

  //同步拦截应用列表（过滤已卸载的），并返回当前拦截的应用列表
  void syncFilterAppList(List<AppInfo> installedApps) {
    final installedNames = installedApps.map((e) => e.packageName).toSet();
    final appList = filterAppList.where((a) => installedNames.contains(a.packageName)).toList();
    if (appList.length != filterAppList.length) {
      setFilterAppList(appList);
    }
  }

  //添加到拦截应用列表
  void addAppToFilters(String packageName) {
    final appList = [...filterAppList, FilterApp(packageName: packageName)];
    setFilterAppList(appList);
  }

  //从拦截应用列表移除
  void removeAppFromFilters(String packageName) {
    final appList = filterAppList.whereNot((element) => element.packageName == packageName).toList();
    setFilterAppList(appList);
  }
}

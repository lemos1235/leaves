//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/14
//
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:leaves/constant/filter_mode.dart';
import 'package:leaves/hive/modules/filters_hive.dart';
import 'package:leaves/model/filter_app.dart';
import 'package:leaves/providers/filters_provider.dart';
import 'package:leaves/widgets/card.dart';
import 'package:provider/provider.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({Key? key}) : super(key: key);

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  bool _isLoading = true;

  List<AppInfo> _installedApps = [];

  List<FilterApp> _filterApps = [];

  late FilterMode _filterMode = FilterMode.off;

  @override
  void initState() {
    super.initState();
    //获得当前模式
    _filterMode = context.read<FiltersProvider>().getFilterMode();
    //初始化应用列表
    initAppList();
  }

  void initAppList() async {
    final installedApps = (await InstalledApps.getInstalledApps(true, true));
    var internalPackageNames = context.read<FiltersProvider>().getInternalPackageNames();
    final visibleApps =
        installedApps.where((element) => !internalPackageNames.contains(element.packageName)).toList();
    context.read<FiltersProvider>().syncFilterAppList(visibleApps);

    setState(() {
      _installedApps = visibleApps;
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final filterApps = context.watch<FiltersProvider>().getFilterAppList();
    _filterApps = filterApps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("分应用设置"),
      ),
      body: Column(
        children: [
          _buildModeSelect(),
          Expanded(
            child: _filterMode == FilterMode.off
                ? SizedBox.shrink()
                : _isLoading
                    ? Align(alignment: Alignment(0, -0.2), child: CircularProgressIndicator())
                    : SingleListSection(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return _buildAppItem(_installedApps[index]);
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 2,
                            );
                          },
                          itemCount: _installedApps.length,
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  //模式选择
  Widget _buildModeSelect() {
    return SingleListSection(
      child: Container(
        color: Theme.of(context).cardColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final mode in FilterMode.values)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      _filterMode = mode;
                      context.read<FiltersProvider>().setFilterMode(_filterMode);
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                          value: mode,
                          groupValue: _filterMode,
                          onChanged: (val) {
                            setState(() {
                              _filterMode = val!;
                              context.read<FiltersProvider>().setFilterMode(_filterMode);
                            });
                          }),
                      Text(mode.title),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  //应用项
  Widget _buildAppItem(AppInfo app) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SwitchListTile.adaptive(
        title: Text(app.name!),
        secondary: SizedBox.square(dimension: 45, child: Image.memory(app.icon!)),
        value: checkIsInFilters(app),
        onChanged: (bool value) {
          if (value) {
            context.read<FiltersProvider>().addAppToFilters(app.packageName!);
          } else {
            context.read<FiltersProvider>().removeAppFromFilters(app.packageName!);
          }
        },
      ),
    );
  }

  //检查当前应用是否在拦截列表中
  bool checkIsInFilters(AppInfo appInfo) {
    for (var app in _filterApps) {
      if (app.packageName == appInfo.packageName) {
        return true;
      }
    }
    return false;
  }
}

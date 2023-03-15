//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/14
//
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:leaves/constant/filter_mode.dart';
import 'package:leaves/model/filter_app.dart';
import 'package:leaves/pages/setting/filters/filter_modes.dart';
import 'package:leaves/providers/filters_provider.dart';
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

  FilterMode _filterMode = FilterMode.off;

  @override
  void initState() {
    super.initState();
    initFilters();
  }

  void initFilters() async {
    final installedApps = (await InstalledApps.getInstalledApps(true, true));
    var internalPackageNames = context.read<FiltersProvider>().getInternalPackageNames();
    final visibleApps =
        installedApps.where((element) => !internalPackageNames.contains(element.packageName)).toList();
    context.read<FiltersProvider>().syncFilterAppList(visibleApps);
    final filterMode = context.read<FiltersProvider>().getFilterMode();
    setState(() {
      _installedApps = visibleApps;
      _filterMode = filterMode;
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
      body: Container(
        alignment: Alignment.topCenter,
        child: _isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: SizedBox.shrink(),
              )
            : Column(
                children: [
                  _buildModeSelect(),
                  if (_filterMode != FilterMode.off)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return _buildAppItem(_installedApps[index]);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 1);
                          },
                          itemCount: _installedApps.length,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  //模式选择
  Widget _buildModeSelect() {
    return GestureDetector(
      onTap: () async {
        final mode = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return FilterModesPage(initialMode: _filterMode);
            },
          ),
        );
        if (mode != null) {
          setState(() {
            _filterMode = mode;
          });
        }
      },
      child: Container(
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        margin: EdgeInsets.only(bottom: 8, top: 10),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 20, left: 15),
              child: Text(
                "模式选择",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _filterMode.title,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //应用项
  Widget _buildAppItem(AppInfo app) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: SwitchListTile.adaptive(
          title: Text(app.name!),
          secondary: Image.memory(app.icon!),
          value: checkIsInFilters(app),
          onChanged: (bool value) {
            if (value) {
              context.read<FiltersProvider>().addAppToFilters(app.packageName!);
            } else {
              context.read<FiltersProvider>().removeAppFromFilters(app.packageName!);
            }
          },
        ),
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

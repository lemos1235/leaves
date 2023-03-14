//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/14
//
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({Key? key}) : super(key: key);

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  bool _isLoading = true;

  List<AppInfo> apps = [];

  @override
  void initState() {
    super.initState();
    getApps();
  }

  void getApps() async {
    final installedApps = await InstalledApps.getInstalledApps(true, true);
    setState(() {
      apps = installedApps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("分应用设置"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child:  _isLoading
            ? LinearProgressIndicator()
            : ListView.separated(
          itemBuilder: (context, index) {
            return _buildAppItem(apps[index]);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 1);
          },
          itemCount: apps.length,
        ),
      ),
    );
  }

  Widget _buildAppItem(AppInfo app) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: SwitchListTile.adaptive(
          title: Text(app.name!),
          secondary: Image.memory(app.icon!),
          value: true,
          onChanged: (bool value) {},
        ),
      ),
    );
  }
}

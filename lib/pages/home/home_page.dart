//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/12
//
import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:flutter_vpn/state.dart';
import 'package:leaves/model/proxy.dart';
import 'package:leaves/providers/proxies_provider.dart';
import 'package:leaves/pages/setting/proxies/proxies_page.dart';
import 'package:provider/provider.dart';

enum HomeMenu { proxies, others }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Proxy? currentProxy;

  bool _isLoading = true;

  FlutterVpnState vpnState = FlutterVpnState.disconnected;

  @override
  void initState() {
    super.initState();
    FlutterVpn.prepare();
    FlutterVpn.onStateChanged.listen((s) => setState(() => vpnState = s));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initProxies();
    });
  }

  Future<void> initProxies() async {
    await context.read<ProxiesProvider>().initialize();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentProxy = context.watch<ProxiesProvider>().getCurrentProxy();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: isDark
          ? Theme.of(context)
          : Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.white,
            ),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<HomeMenu>(
              // Callback that sets the selected popup menu item.
              onSelected: (HomeMenu item) {
                if (item == HomeMenu.proxies) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return ProxiesPage();
                  }));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<HomeMenu>>[
                const PopupMenuItem<HomeMenu>(
                  value: HomeMenu.proxies,
                  child: Text('配置代理'),
                ),
                // const PopupMenuItem<MenuItem>(
                //   value: MenuItem.others,
                //   child: Text('其它'),
                // ),
              ],
            ),
          ],
        ),
        body: Align(
          alignment: Alignment(0.0, -0.15),
          child: _isLoading
              ? CircularProgressIndicator()
              : currentProxy == null
                  ? goToProxiesSettingButton()
                  : vpnButton(),
        ),
      ),
    );
  }

  Widget goToProxiesSettingButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProxiesPage()));
      },
      child: Text(
        "配置代理",
        style: TextStyle(
          fontSize: 28,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget vpnButton() {
    return GestureDetector(
      onTap: () {
        if (vpnState == FlutterVpnState.disconnected) {
          FlutterVpn.connect(proxy: currentProxy!.toProxyUri());
        } else if (vpnState == FlutterVpnState.connected) {
          FlutterVpn.disconnect();
        }
      },
      child: vpnState == FlutterVpnState.disconnected
          ? Text("立刻启动",
              style: TextStyle(
                fontSize: 36,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ))
          : Text("停止",
              style: TextStyle(
                fontSize: 36,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              )),
    );
  }
}

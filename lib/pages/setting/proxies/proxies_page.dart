//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/12
//
import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:flutter_vpn/state.dart';
import 'package:leaves/model/proxy.dart';
import 'package:leaves/providers/proxies_provider.dart';
import 'package:leaves/pages/setting/proxies/proxy_page.dart';
import 'package:provider/provider.dart';

enum ProxyItemMenu { edit, delete }

class ProxiesPage extends StatefulWidget {
  const ProxiesPage({Key? key}) : super(key: key);

  @override
  State<ProxiesPage> createState() => _ProxiesPageState();
}

class _ProxiesPageState extends State<ProxiesPage> {
  late List<Proxy> proxyList;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    proxyList = context.watch<ProxiesProvider>().getProxyList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: isDark
          ? Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.black,
            )
          : Theme.of(context).copyWith(
              cardTheme: CardTheme(
              elevation: 0.5,
            )),
      child: Scaffold(
        appBar: AppBar(
          title: Text("代理服务器配置"),
          actions: [
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  final newProxy = await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return ProxyEditPage();
                  }));
                  if (newProxy != null) {
                    final index = proxyList.length;
                    proxyList.insert(index, newProxy);
                    _listKey.currentState?.insertItem(index);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).primaryColor.withOpacity(0.1),
                  //   shape: BoxShape.circle,
                  // ),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: AnimatedList(
          key: _listKey,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return buildProxyItem(proxyList[index]);
          },
          initialItemCount: proxyList.length,
        ),
      ),
    );
  }

  Widget buildProxyItem(Proxy proxy) {
    final itemBgColor =
        proxy.isCurrent ? Theme.of(context).primaryColor.withOpacity(0.8) : Theme.of(context).cardColor;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: proxy.isCurrent ? null : () => switchProxy(proxy),
      child: Card(
        color: itemBgColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    proxy.getName(),
                    style: TextStyle(fontSize: 20),
                  ),
                  // Icon(Icons.more_vert),
                  PopupMenuButton<ProxyItemMenu>(
                    padding: EdgeInsets.all(3),
                    onSelected: (ProxyItemMenu item) {
                      if (item == ProxyItemMenu.edit) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return ProxyEditPage(
                            proxy: proxy,
                          );
                        }));
                      } else if (item == ProxyItemMenu.delete) {
                        showDeleteSheet(proxy.id);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<ProxyItemMenu>>[
                      const PopupMenuItem<ProxyItemMenu>(
                        value: ProxyItemMenu.edit,
                        child: Text('编辑'),
                      ),
                      const PopupMenuItem<ProxyItemMenu>(
                        value: ProxyItemMenu.delete,
                        child: Text('删除'),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text("地址："),
                        Text(proxy.host),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text("端口："),
                        Text(proxy.port.toString()),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text("协议："),
                        Text(proxy.scheme),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text("认证："),
                        Text((proxy.username?.isNotEmpty ?? false) ? "有" : "无"),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void switchProxy(Proxy proxy) async {
    context.read<ProxiesProvider>().setCurrentId(proxy.id);
    final vpnState = await FlutterVpn.currentState;
    if (vpnState == FlutterVpnState.connected) {
      FlutterVpn.switchProxy(proxy: proxy.toProxyUri());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("已切换")));
    }
  }

  void showDeleteSheet(String id) {
    final padding = MediaQuery.of(context).padding;
    final themeData = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  context.read<ProxiesProvider>().deleteProxy(id);
                  Navigator.of(context).pop();
                  final index = proxyList.indexWhere((element) => element.id == id);
                  final removedItem = proxyList.removeAt(index);
                  _listKey.currentState?.removeItem(
                    index,
                    (context, animation) => SlideTransition(
                      position: Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(animation),
                      child: buildProxyItem(removedItem),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "删除",
                    style: TextStyle(
                      color: themeData.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Divider(),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "取消",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

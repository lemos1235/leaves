//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/12
//
import 'package:flutter/material.dart';
import 'package:leaves/model/proxy_servers.dart';
import 'package:leaves/setting/proxy_add_page.dart';
import 'package:leaves/setting/proxy_edit_page.dart';
import 'package:provider/provider.dart';

class ProxiesPage extends StatefulWidget {
  const ProxiesPage({Key? key}) : super(key: key);

  @override
  State<ProxiesPage> createState() => _ProxiesPageState();
}

class _ProxiesPageState extends State<ProxiesPage> {
  late List<ProxyItem> proxyList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    proxyList = context.watch<ProxyServers>().getProxyList();
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
          elevation: 4,
        )
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("代理服务器配置"),
          actions: [
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return ProxyAddPage();
                  }));
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
        body: ListView(
          children: proxyList.map((e) => buildProxyItem(e)).toList(),
        ),
      ),
    );
  }

  Widget buildProxyItem(ProxyItem proxy) {
    final itemBgColor =
        proxy.isCurrent ? Theme.of(context).primaryColor.withOpacity(0.8) : Theme.of(context).cardColor;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: proxy.isCurrent ? null : () => toggleProxy(proxy),
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
                        Text(proxy.protocol),
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

  void toggleProxy(Proxy proxy) {
    context.read<ProxyServers>().setCurrent(proxy.id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("已切换")));
  }

  void showDeleteSheet(String id) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // useSafeArea: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    context.read<ProxyServers>().deleteProxy(id);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "删除",
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
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
        });
  }
}

enum ProxyItemMenu { edit, delete }

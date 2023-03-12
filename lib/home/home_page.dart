import 'package:flutter/material.dart';
import 'package:leaves/model/proxy_servers.dart';
import 'package:leaves/setting/proxies_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MenuItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    Proxy? proxy = context.watch<ProxyServers>().getCurrentProxy();
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<MenuItem>(
            initialValue: selectedMenu,
            // Callback that sets the selected popup menu item.
            onSelected: (MenuItem item) {
              setState(() {
                selectedMenu = item;
              });
              if (selectedMenu == MenuItem.proxyServers) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return ProxiesPage();
                }));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
              const PopupMenuItem<MenuItem>(
                value: MenuItem.proxyServers,
                child: Text('代理服务器'),
              ),
              const PopupMenuItem<MenuItem>(
                value: MenuItem.others,
                child: Text('其它'),
              ),
            ],
          ),
        ],
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment(0.0, -0.15),
        child: GestureDetector(
          onTap: () {},
          child: Text(
            "立刻启动",
            style: TextStyle(
              fontSize: 36,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

enum MenuItem { proxyServers, others }

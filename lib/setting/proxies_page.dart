//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/12
//
import 'package:flutter/material.dart';
import 'package:leaves/model/proxy_servers.dart';
import 'package:provider/provider.dart';

class ProxiesPage extends StatefulWidget {
  const ProxiesPage({Key? key}) : super(key: key);

  @override
  State<ProxiesPage> createState() => _ProxiesPageState();
}

class _ProxiesPageState extends State<ProxiesPage> {
  @override
  Widget build(BuildContext context) {
    final proxyList = context.watch<ProxyServers>().getProxyList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("代理服务器配置"),
        centerTitle: true,
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: ListView(
        children: proxyList.map((e) => buildProxyItem(e)).toList(),
      ),
    );
  }

  Widget buildProxyItem(ProxyItem proxy) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: proxy.isCurrent ? Theme.of(context).primaryColor.withOpacity(0.8) : Color(0xFF303030),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                proxy.getName(),
                style: TextStyle(fontSize: 20),
              ),
              Icon(Icons.more_vert),
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
                    Text(proxy.port),
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
    );
  }
}

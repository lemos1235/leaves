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
    context.read<ProxyServers>().toString();
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [],
      ),
    );
  }
}

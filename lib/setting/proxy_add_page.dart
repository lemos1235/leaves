import 'package:flutter/material.dart';
import 'package:leaves/model/proxy_servers.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class ProxyAddPage extends StatefulWidget {
  const ProxyAddPage({Key? key}) : super(key: key);

  @override
  State<ProxyAddPage> createState() => _ProxyAddPageState();
}

class _ProxyAddPageState extends State<ProxyAddPage> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新增代理服务器"),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              saveProxy();
            },
            child: Icon(Icons.done),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TextFormField(
                controller: _hostController,
                decoration: InputDecoration(labelText: "地址："),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '请输入地址';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _portController,
                decoration: InputDecoration(labelText: "端口："),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '请输入端口';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "用户：", hintText: "可选的"),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "密码：", hintText: "可选的，最大长度128"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveProxy() {
    if (_formKey.currentState!.validate()) {
      context.read<ProxyServers>().addProxy(
            host: _hostController.text,
            port: int.parse(_portController.text),
            username: _usernameController.text,
            password: _passwordController.text,
          );
      Navigator.of(context).pop();
    }
  }
}

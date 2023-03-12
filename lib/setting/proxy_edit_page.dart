import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leaves/model/proxy_servers.dart';
import 'package:provider/provider.dart';

class ProxyEditPage extends StatefulWidget {
  const ProxyEditPage({Key? key, required this.proxy}) : super(key: key);

  final Proxy proxy;

  @override
  State<ProxyEditPage> createState() => _ProxyEditPageState();
}

class _ProxyEditPageState extends State<ProxyEditPage> {
  late TextEditingController _hostController;

  late TextEditingController _portController;

  late TextEditingController _usernameController;

  late TextEditingController _passwordController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: widget.proxy.host);
    _portController = TextEditingController(text: widget.proxy.port.toString());
    _usernameController = TextEditingController(text: widget.proxy.username);
    _passwordController = TextEditingController(text: widget.proxy.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("编辑代理服务器"),
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
      context.read<ProxyServers>().updateProxy(widget.proxy.copyWith(
            host: _hostController.text,
            port: int.parse(_portController.text),
            username: _usernameController.text,
            password: _passwordController.text,
          ));
      Navigator.of(context).pop();
    }
  }
}

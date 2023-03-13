import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leaves/model/proxy.dart';
import 'package:leaves/providers/proxies_provider.dart';
import 'package:provider/provider.dart';

class ProxyEditPage extends StatefulWidget {
  const ProxyEditPage({Key? key, this.proxy}) : super(key: key);

  final Proxy? proxy;

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
    _hostController = TextEditingController(text: widget.proxy?.host);
    _portController = TextEditingController(text: widget.proxy?.port.toString());
    _usernameController = TextEditingController(text: widget.proxy?.username);
    _passwordController = TextEditingController(text: widget.proxy?.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.proxy == null ? '添加' : '编辑'}代理服务器"),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              saveProxy();
            },
            child: Container(padding: EdgeInsets.all(5), child: Icon(Icons.done, size: 30)),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Card(
        elevation: 5,
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _hostController,
                  decoration: InputDecoration(
                    labelText: "地址：",
                    hintText: "必填，请输入IP地址",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '请输入地址';
                    }
                    try {
                      Uri.parseIPv4Address(value);
                    } catch (e) {
                      return '请输入正确的IP地址';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _portController,
                  decoration: InputDecoration(
                    labelText: "端口：",
                    hintText: "必填， 1-65535",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '请输入端口';
                    }
                    if (int.parse(value) < 1 || int.parse(value) > 65535) {
                      return '端口范围须在 1-65535';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "用户：",
                    hintText: "可选的",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "密码：",
                    hintText: "可选，最大长度128",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveProxy() {
    if (_formKey.currentState!.validate()) {
      if (widget.proxy != null) {
        context.read<ProxiesProvider>().updateProxy(widget.proxy!.copyWith(
              host: _hostController.text,
              port: int.parse(_portController.text),
              username: _usernameController.text,
              password: _passwordController.text,
            ));
        Navigator.of(context).pop();
      } else {
        Proxy newProxy = context.read<ProxiesProvider>().addProxy(
              host: _hostController.text,
              port: int.parse(_portController.text),
              username: _usernameController.text,
              password: _passwordController.text,
            );
        Navigator.of(context).pop(newProxy);
      }
    }
  }
}

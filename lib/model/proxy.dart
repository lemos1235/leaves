//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/12
//
class Proxy {
  final String id;
  final String label;
  final String scheme;
  final String host;
  final int port;
  final String? username;
  final String? password;

  bool isCurrent = false;

  //获取名称
  String getName() {
    return label.isNotEmpty ? label : host.split(".").last;
  }

  // 转换成uri字符串
  String toProxyUri() {
    if (username?.isNotEmpty ?? false) {
      return "$scheme://$username:$password@$host:$port";
    }
    return "$scheme://$host:$port";
  }

  Proxy({
    required this.id,
    required this.scheme,
    required this.host,
    required this.port,
    this.username,
    this.password,
    this.label = "",
    this.isCurrent = false,
  });

  Proxy copyWith({
    String? id,
    String? scheme,
    String? host,
    int? port,
    String? username,
    String? password,
    String? label,
    bool? isCurrent,
  }) {
    return Proxy(
      id: id ?? this.id,
      scheme: scheme ?? this.scheme,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      label: label ?? this.label,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  factory Proxy.fromJson(dynamic json) {
    return Proxy(
      id: json['id'],
      scheme: json['scheme'],
      host: json['host'],
      port: json['port'],
      username: json['username'],
      password: json['password'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['scheme'] = scheme;
    map['host'] = host;
    map['port'] = port;
    map['username'] = username;
    map['password'] = password;
    map['label'] = label;
    return map;
  }
}

//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/13
//
import 'package:hive/hive.dart';

export 'modules/proxies_hive.dart';

class HiveBoxes {
  const HiveBoxes._();

  static const String proxiesBox = 'proxies';
  static const String filtersBox = 'filters';

  static Future<void> openBoxes() async {
    await Future.wait([
      Hive.openBox(proxiesBox),
      Hive.openBox(filtersBox),
    ]);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:leaves/hive/hive_boxes.dart';
import 'package:leaves/pages/home/home_page.dart';
import 'package:leaves/providers/providers.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveBoxes.openBoxes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    Intl.defaultLocale = "zh";
    return MaterialApp(
      title: 'Leaves',
      debugShowCheckedModeBanner: false,
      // scrollBehavior: CupertinoScrollBehavior(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        primaryColor: Color(0xFFF97800),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFF97800),
          secondary: Color(0xFFF97800),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF97800),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          color: Color(0xFF303030),
        ),
        dividerColor: Color(0xFF303030),
        cardTheme: const CardTheme(
          shadowColor: Color(0xFF303030),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF303030),
          contentTextStyle: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(borderSide: const BorderSide(color: Color(0xFF8A8787))),
          focusedBorder: UnderlineInputBorder(borderSide: const BorderSide(color: Color(0xFF8A8787))),
        ),
      ),
      scrollBehavior: CupertinoScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Color(0xFFF97800),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          toolbarTextStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black87,
          selectedLabelStyle: TextStyle(fontSize: 12),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          shadowColor: Color(0xFFEEEEEE),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
          enabledBorder: UnderlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
          focusedBorder: UnderlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0xDD000000),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('zh', 'CN'),
      ],
      home: const HomePage(),
      builder: (context, child) {
        return MultiProvider(
          providers: providers,
          child: child,
        );
      },
    );
  }
}

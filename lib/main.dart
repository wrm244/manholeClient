import 'package:flutter/material.dart';
import 'login.dart';
import 'mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? debugLabel = 'Unknown';
  bool isLoggedIn = false;

  // 定义一个全局的 GlobalKey<NavigatorState>
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      });
      if (isLoggedIn) {
        navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
          builder: (context) => const Mainpage(),
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 设置navigatorKey
      home: const SignInPage2(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project10/HomePage.dart';
import 'package:project10/LoginPage.dart';
import 'SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[850],
        primaryColor: Colors.blueGrey[700],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[800],
        ),
        cardColor: Colors.grey[800],
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Colors.pinkAccent),
          trackColor: MaterialStateProperty.all(Colors.grey),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.grey[200]),
        ),
      ),
      themeMode: themeMode,
      home: SplashScreen(),
    );
  }
}

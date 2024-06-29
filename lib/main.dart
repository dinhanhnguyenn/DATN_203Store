import 'package:app_203store/views/AccountScreen.dart';
import 'package:app_203store/views/AddProductScreen.dart';
import 'package:app_203store/views/HomeScreen.dart';
import 'package:app_203store/views/MainScreen.dart';
import 'package:app_203store/views/NotificationsScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        //'/':(context) => const AddProductsScreen(),
        '/home':(context) => const HomeScreen(),
        '/notifi':(context) => const NotificationsScreen(),
        '/profile': (context) => const AccountScreen()
      },
    );
  }
}

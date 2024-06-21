import 'package:app_203store/page/Forget_Page.dart';
import 'package:app_203store/page/Login_Page.dart';
import 'package:app_203store/page/Register_Page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Forget());
  }
}

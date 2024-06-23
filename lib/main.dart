import 'package:app_203store/views/AddProduct_Page.dart';
import 'package:app_203store/views/Cart_Page.dart';
import 'package:app_203store/views/ForgetPass_Page.dart';
import 'package:app_203store/views/Login_Page.dart';
import 'package:app_203store/views/Payment_Page.dart';
import 'package:app_203store/views/Register_Page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Cart());
  }
}

import 'package:app_203store/views/AccountScreen.dart';
import 'package:app_203store/views/AddProductDetail.dart';
import 'package:app_203store/views/AddProductScreen.dart';
import 'package:app_203store/views/AdminScreen.dart';
import 'package:app_203store/views/Cart_Page.dart';
import 'package:app_203store/views/CategoriesManagerScreen.dart';
import 'package:app_203store/views/ForgetPass_Page.dart';
import 'package:app_203store/views/HomeScreen.dart';
import 'package:app_203store/views/Login_Page.dart';
import 'package:app_203store/views/MainScreen.dart';
import 'package:app_203store/views/NotificationsScreen.dart';
import 'package:app_203store/views/ProductsManagerScreen.dart';
import 'package:app_203store/views/Register_Page.dart';
import 'package:app_203store/views/UpdateProductsScreen.dart';
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
      initialRoute: '',
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const Register(),
        '/home':(context) => const HomeScreen(),
        '/notifi':(context) => const NotificationsScreen(),
        '/profile': (context) => const AccountScreen(),
        '/addproduct': (context) => const AddProductsScreen(),
        '/productmanager': (context) => const ProductManagerScreen(),
        '/categorymanager':(context) => const CategoriesManagerScreen(),
        '/admin':(context) => const AdminScreen(),
        '/addproductdetail':(context) => const AddProductDetailScreen()
      },
    );
  }
}

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
import 'package:app_203store/views/OrderManager.dart';
import 'package:app_203store/views/Payment_Page.dart';
import 'package:app_203store/views/Register_Page.dart';
import 'package:app_203store/views/ReviewManager.dart';
import 'package:app_203store/views/Statistics_Page.dart';
import 'package:app_203store/views/UpdateProductsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_203store/models/UserProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(0)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => Register(),
        '/': (context) => MainScreen(),
        '/home': (context) => HomeScreen(),
        '/notifi': (context) => const NotificationsScreen(),
        '/addproduct': (context) => const AddProductsScreen(),
        '/cart': (context) => const Cart(),
        '/order': (context) => ManageOrdersPage(),
        '/review': (AboutDialog) => ReviewManager(),
        '/admin': (context) => AdminScreen(),
        '/statistics': (context) => StatisticsPage(),
      },
    );
  }
}

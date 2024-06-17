import 'package:app_203store/pages/homePage.dart';
import 'package:app_203store/pages/searchPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(App203Store());

class App203Store extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      routes: {
        "/":(context) => HomePage(),
        "searchPage" : (context) => SearchPage()
        //"/":(context) => SearchPage(),
      },
    );
  }
}
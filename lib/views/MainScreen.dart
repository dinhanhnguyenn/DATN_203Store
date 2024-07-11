import 'package:app_203store/views/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/AccountScreen.dart';
import 'package:app_203store/views/HomeScreen.dart';
import 'package:app_203store/views/NotificationsScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeScreen(),
      AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 60.0,
        items: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.account_circle_outlined, size: 30),
        ],
        color: Colors.lightBlue[200]!,
        buttonBackgroundColor: Colors.lightBlue[200]!,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1 || index == 2) {
            int userId =
                Provider.of<UserProvider>(context, listen: false).userId;
            if (userId == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          }
        },
      ),
    );
  }
}

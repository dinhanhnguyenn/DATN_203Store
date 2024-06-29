import 'package:app_203store/views/AccountScreen.dart';
import 'package:app_203store/views/HomeScreen.dart';
import 'package:app_203store/views/NotificationsScreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const NotificationsScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        },
        child: Icon(
          Icons.phone_in_talk, 
          color: Colors.white
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60.0,
        items: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.notifications_active, size: 30),
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
        },
      ),
    );
  }
}






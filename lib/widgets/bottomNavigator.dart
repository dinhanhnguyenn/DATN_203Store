import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      onTap: (index){},
      height: 60,
      color: Color(0xffd9d9d9),
      items: const [
        Icon(
          Icons.home,
          color: Colors.black,
          size: 30,
        ),
        Icon(
          Icons.notifications_active,
          color: Colors.black,
          size: 30,
        ),
        Icon(
          Icons.account_circle,
          color: Colors.black,
          size: 30
        )
      ],
    );
  }
}
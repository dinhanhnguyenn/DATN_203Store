import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "203 Store",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.blue
                    ),
                  ),
                  Text(
                    "Cung cấp các sản phẩm Apple chính hãng",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ),
      body: Center(
        child: Text("Notification"),
      ),
    );
  }
}
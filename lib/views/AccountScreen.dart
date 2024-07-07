import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/UpdateProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late int userId;
  String username = '';
  String email = '';
  String fullName = '';
  String address = '';
  String phone = '';

  Future<void> _getUserInfo() async {
    userId = Provider.of<UserProvider>(context, listen: false).userId;
    final response = await http.post(
      Uri.parse('http://192.168.30.103/flutter/get_user_info.php'),
      body: {'user_id': userId.toString()},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        setState(() {
          username = jsonResponse['username'] ?? ' ';
          email = jsonResponse['email'] ?? ' ';
          fullName = jsonResponse['full_name'] ?? ' ';
          address = jsonResponse['address'] ?? ' ';
          phone = jsonResponse['phone'] ?? ' ';
        });
      } else {
        setState(() {
          username = ' ';
          email = ' ';
          fullName = ' ';
          address = ' ';
          phone = ' ';
        });
      }
    } else {
      setState(() {
        username = ' ';
        email = ' ';
        fullName = ' ';
        address = ' ';
        phone = ' ';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserProvider>(context, listen: false).userId;
    _getUserInfo();
  }

  void _logout() {
    Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
              ),
              child: Text(
                'Tài Khoản',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Cập Nhật Thông Tin'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProfile(
                              userId: userId,
                            )));
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Lịch Sử Giao Dịch'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Tài khoản'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Expanded(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/user.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$username',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Thông Tin Cá Nhân',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Tên : $fullName'),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email : $email'),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Điện Thoại : $phone'),
                ),
                ListTile(
                  leading: Icon(Icons.home_filled),
                  title: Text('Địa Chỉ : $address'),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.0),
        ],
      ),
    );
  }
}

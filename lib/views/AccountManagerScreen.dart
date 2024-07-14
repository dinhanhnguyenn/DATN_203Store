import 'dart:convert';

import 'package:app_203store/models/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AccountManagerScreen extends StatefulWidget {
  const AccountManagerScreen({super.key});

  @override
  State<AccountManagerScreen> createState() => _AccountManagerScreenState();
}

class _AccountManagerScreenState extends State<AccountManagerScreen> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.6/flutter/loadUser.php'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          users = (json.decode(response.body) as List).map((data) {
            return {
              ...data,
              'user_id': int.parse(data['user_id'].toString()),
              'status': int.parse(data['status']
                  .toString()), // Chuyển đổi status thành số nguyên
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateReviewStatus(int userId, int status) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6/flutter/updateAccountStatus.php'),
        body: {
          'user_id': userId.toString(),
          'status': status.toString(),
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thành công!')),
        );
        fetchUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thất bại.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Đã xảy ra lỗi trong quá trình cập nhật trạng thái.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: Text('Quản lý tài khoản'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Tài khoản: ${user['username']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user['email']}'),
                        Text('Địa chỉ: ${user['address']}'),
                        Text('Điện thoại: ${user['phone']}'),
                      ],
                    ),
                    trailing: Switch(
                      value: user['status'] == 1,
                      onChanged: (value) {
                        int newStatus = value ? 1 : 0;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Đổi trạng thái tài khoản'),
                              content: Text(newStatus == 1
                                  ? 'Bạn có chắc chắn muốn khôi phục tài khoản này không?'
                                  : 'Bạn có chắc chắn muốn khóa tài khoản này không?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Hủy'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Đồng ý'),
                                  onPressed: () {
                                    updateReviewStatus(
                                        user['user_id'], newStatus);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

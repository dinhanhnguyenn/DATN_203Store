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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.lightBlue[200],
          title: const Text("Quản lý tài khoản"),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: loadAccountByAdmin(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có dữ liệu'));
              } else {
                List<dynamic> accountListByAdmin = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 4,
                    ),
                    itemCount: accountListByAdmin.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Username: ${accountListByAdmin[index]["username"]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            User del = User(
                                                user_id:
                                                    accountListByAdmin[index]
                                                        ["user_id"],
                                                full_name: "",
                                                password: "",
                                                username: "",
                                                status: "");
                                            userDelete(del);
                                          },
                                          icon: const Icon(Icons.lock_rounded),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ));
  }

  Future<List> loadAccountByAdmin() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.4/flutter/loadAccount.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Load thất bại');
    }
  }

  Future userDelete(User pro) async {
    final uri = Uri.parse('http://192.168.1.4/flutter/deleteAccount.php');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = pro.user_id;

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Xóa thành công");
    } else {
      print("Xóa thất bại");
    }
  }
}

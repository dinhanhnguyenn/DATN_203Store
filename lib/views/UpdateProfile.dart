import 'dart:convert';

import 'package:app_203store/views/AccountScreen.dart';
import 'package:app_203store/views/MainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  final int userId;
  const UpdateProfile({Key? key, required this.userId}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountScreen(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Hoàn thiện thông tin để mua sắm nào !",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fullNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Họ và Tên',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Điện Thoại',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String username = _usernameController.text;
                  String fullName = _fullNameController.text;
                  String phone = _phoneController.text;
                  String address = _addressController.text;

                  if (username.isEmpty ||
                      fullName.isEmpty ||
                      phone.isEmpty ||
                      address.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Vui lòng nhập đầy đủ thông tin.')),
                    );
                    return;
                  }

                  // Gọi hàm để gửi yêu cầu cập nhật thông tin người dùng
                  updateUserInfo(username, fullName, phone, address);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.lightBlue[200],
                ),
                child: Text(
                  'Lưu',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUserInfo(
      String username, String fullName, String phone, String address) async {
    final url = Uri.parse(
        'http://192.168.30.35/flutter/update_user_info.php'); // Thay đổi thành URL của API PHP của bạn
    final response = await http.post(
      url,
      body: {
        'user_id': widget.userId.toString(),
        'username': username,
        'full_name': fullName,
        'phone': phone,
        'address': address,
      },
    );

    if (response.statusCode == 200) {
      // Xử lý khi cập nhật thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thông tin thành công')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      // Xử lý khi có lỗi từ phía server
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật thông tin')),
      );
    }
  }
}

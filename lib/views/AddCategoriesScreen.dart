import 'dart:convert';
import 'dart:io';

import 'package:app_203store/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({super.key});

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  Category newcategory =
      Category(category_id: "", category_name: "", status: "");
  var loai = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Thêm danh mục"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Row(
              children: [
                Expanded(
                  child: Text(
                    "Tên danh mục ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: loai,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                prefixIcon: const Icon(Icons.shopping_cart_rounded),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (loai.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Vui lòng nhập tên loại sản phẩm')),
                      );
                      return;
                    }
                    else{
                      Category add = Category(
                        category_id: "",
                        category_name: loai.text,
                        status: 1.toString()
                      );
                      categoriesAdd(add);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(180, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Colors.lightBlue[200]),
                  child: const Text(
                    "Thêm mới",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ]),
        ),
      )
    );
  }
  Future categoriesAdd(Category loai) async {
    final uri = Uri.parse('http://192.168.1.5/flutter/addCategories.php');
    print(loai.category_name);
    final response = await http.post(uri,
      body: {'category_name': loai.category_name, 'status': loai.status}
    );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm sản phẩm thành công')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi thêm sản phẩm')),
        );
      }
  }
}



import 'dart:convert';
import 'dart:io';

import 'package:app_203store/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateCategoriesScreen extends StatefulWidget {
  UpdateCategoriesScreen({super.key, required this.categories});
  var categories;
  @override
  State<UpdateCategoriesScreen> createState() => _UpdateCategoriesScreenState();
}

class _UpdateCategoriesScreenState extends State<UpdateCategoriesScreen> {
  Category newcategory =
      Category(category_id: "", category_name: "", status: "");
  var loai = TextEditingController();

  @override
  void initState() {
    super.initState();
    loai.text = widget.categories["category_name"];
  }

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
                      Category add = Category(
                          category_id: widget.categories['category_id'],
                          category_name: loai.text,
                          status: 1.toString());

                      categoriesUpdate(add);
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(180, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Colors.lightBlue[200]),
                    child: const Text(
                      "Cập nhật",
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
        ));
  }
}

Future categoriesUpdate(Category loai) async {
  final uri = Uri.parse('http://192.168.30.35/flutter/updateCategories.php');
  print(loai.category_name);
  http.post(uri, body: {
    'category_id': loai.category_id,
    'category_name': loai.category_name,
    'status': loai.status
  });
}

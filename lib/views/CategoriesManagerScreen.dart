import 'dart:convert';

import 'package:app_203store/models/Category.dart';
import 'package:app_203store/views/AddCategoriesScreen.dart';
import 'package:app_203store/views/UpdateCategoriesScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriesManagerScreen extends StatefulWidget {
  const CategoriesManagerScreen({super.key});

  @override
  State<CategoriesManagerScreen> createState() =>
      _CategoriesManagerScreenState();
}

class _CategoriesManagerScreenState extends State<CategoriesManagerScreen> {
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
          title: const Text("Quản lý danh mục"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCategoriesScreen(),
              ),
            );
          },
          child: Icon(Icons.add_circle, color: Colors.white),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: loadCategoriesByAdmin(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                List<dynamic> categoryListByAdmin = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 6,
                    ),
                    itemCount: categoryListByAdmin.length,
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${categoryListByAdmin[index]["category_name"]}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          140,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Category del = Category(
                                                  category_id:
                                                      categoryListByAdmin[index]
                                                          ["category_id"],
                                                  category_name: "",
                                                  status: "");
                                              categoryDelete(del);
                                            },
                                            icon: const Icon(
                                                Icons.restore_from_trash),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateCategoriesScreen(
                                                          categories:
                                                              categoryListByAdmin[
                                                                  index]),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.edit),
                                          )
                                        ],
                                      ),
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
}

Future<List> loadCategoriesByAdmin() async {
  final response = await http
      .get(Uri.parse('http://192.168.1.6/flutter/loadCategoriesByAdmin.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Load thất bại');
  }
}

Future categoryDelete(Category pro) async {
  final uri = Uri.parse('http://192.168.1.6/flutter/deleteCategories.php');
  var request = http.MultipartRequest('POST', uri);

  request.fields['category_id'] = pro.category_id;

  var response = await request.send();

  if (response.statusCode == 200) {
    print("Xóa thành công");
  } else {
    print("Xóa thất bại");
  }
}

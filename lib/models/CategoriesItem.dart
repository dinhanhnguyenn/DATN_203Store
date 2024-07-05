import 'dart:convert';

import 'package:app_203store/views/Cart_Page.dart';
import 'package:app_203store/views/CategoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriesItem extends StatefulWidget {
  const CategoriesItem({super.key});

  @override
  State<CategoriesItem> createState() => _CategoriesItemState();
}

class _CategoriesItemState extends State<CategoriesItem> {
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadCategories(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          List<dynamic> categoryList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 3.5,
              ),
              itemCount: categoryList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(category: categoryList[index]),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 30,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[200],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "${categoryList[index]["category_name"]}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      }
    );
  }
}

Future<List> loadCategories() async {
  final response = await http.get(Uri.parse('http://192.168.1.15/flutter/loadCategories.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Load thất bại');
  }
}
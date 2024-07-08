import 'dart:convert';

import 'package:app_203store/views/DetailProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _products = [];

  Future<void> _searchProducts(String searchChar) async {
    final response = await http.get(Uri.parse(
        'http://192.168.30.103/flutter/searchProduct.php?search=$searchChar'));

    if (response.statusCode == 200) {
      setState(() {
        _products = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: Text('Tìm kiếm sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nhập tên sản phẩm',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchProducts(_searchController.text),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _products.isEmpty
                  ? const Center(child: Text('Không tìm thấy sản phẩm'))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: _products.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailProduct(product: _products[index]),
                                ),
                              );
                            },
                            child: Card(
                              color: const Color(0xFFD9D9D9),
                              elevation: 7.0,
                              child: ListTile(
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Image.network(
                                          "http://192.168.30.103/flutter/uploads/${_products[index]["image"]}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "${_products[index]["name"]}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Text(
                                        ' ${_products[index]["price"]} VND',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List> loadProduct() async {
    final response = await http
        .get(Uri.parse('http://192.168.30.103/flutter/loadProduct.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Load thất bại');
    }
  }
}

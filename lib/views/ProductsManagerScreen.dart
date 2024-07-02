import 'dart:convert';

import 'package:app_203store/models/Product.dart';
import 'package:app_203store/views/AddProductScreen.dart';
import 'package:app_203store/views/UpdateProductsScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductManagerScreen extends StatefulWidget {
  const ProductManagerScreen({super.key});
  @override
  State<ProductManagerScreen> createState() => _ProductManagerScreenState();
}

class _ProductManagerScreenState extends State<ProductManagerScreen> {

  Future<void> _loadData() async {
    await Future.delayed(Duration(seconds: 2));
    print("Data loaded");
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _loadData(); // Initial data load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: const Text("Quản lý sản phẩm"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductsScreen()),
          );
          if (result == true) {
            _loadData();
          }
        },
        child: Icon(
          Icons.add_circle,
          color: Colors.white
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: loadProductByAdmin(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              List<dynamic> productListByAdmin = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 2.75,
                  ),
                  itemCount: productListByAdmin.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network("http://192.168.1.6/flutter/uploads/${productListByAdmin[index]["image"]}", fit: BoxFit.cover),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sản phẩm: ${productListByAdmin[index]["name"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Số lượng: ${productListByAdmin[index]["quantity"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 140,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        IconButton(
                                          onPressed: () {   
                                            Product add = Product(
                                              product_id: productListByAdmin[index]['product_id'],
                                              name: "", 
                                              image: "", 
                                              price: "",
                                              quantity: "",
                                              category_id: "",
                                              description: "",
                                              status: ""
                                            );
                                            productDelete(add);                 
                                          },
                                          icon: const Icon(Icons.restore_from_trash),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UpdateProductScreen(product: productListByAdmin[index]),
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
      )
    );
  }
}

Future<List> loadProductByAdmin() async {
  final response = await http.get(Uri.parse('http://192.168.1.6/flutter/loadProductByAdmin.php'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Load thất bại');
  }
}

Future productDelete(Product pro) async {
  final uri = Uri.parse('http://192.168.1.6/flutter/deleteProduct.php');
  var request = http.MultipartRequest('POST', uri);
 
  request.fields['product_id'] = pro.product_id;

  var response = await request.send();

  if (response.statusCode == 200) {
    print("Xóa thành công");
  } else {
    print("Xóa thất bại");
  }
}

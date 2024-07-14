import 'dart:convert';

import 'package:app_203store/models/Product.dart';
import 'package:app_203store/views/AddProductDetail.dart';
import 'package:app_203store/views/AddProductScreen.dart';
import 'package:app_203store/views/InfoProduct.dart';
import 'package:app_203store/views/InputProductDetail.dart';
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
    await Future.delayed(const Duration(seconds: 2));
    print("Data loaded");
    setState(() {
      const ProductManagerScreen();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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
          title: const Text("Quản lý sản phẩm"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductsScreen()),
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
            future: loadProductByAdmin(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có dữ liệu'));
              } else {
                List<dynamic> productListByAdmin = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black, width: 2.0)),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                    "http://192.168.1.5/flutter/uploads/${productListByAdmin[index]["image"]}",
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${productListByAdmin[index]["name"]}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.start,
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InfoProduct(
                                                          product:
                                                              productListByAdmin[
                                                                  index])),
                                            );
                                          },
                                          icon: const Icon(Icons.info),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          140,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          InputProductDetail(
                                                            product:
                                                                productListByAdmin[
                                                                    index],
                                                          )),
                                                );
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.lightBlue[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 2.0)),
                                                  child: Text(
                                                    " Nhập ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ))),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddProductDetailScreen(
                                                          product:
                                                              productListByAdmin[
                                                                  index],
                                                        )),
                                              );
                                            },
                                            icon: const Icon(Icons.add_circle),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateProductScreen(
                                                          product:
                                                              productListByAdmin[
                                                                  index]),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.edit),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Xác nhận xóa sản phẩm'),
                                                    content: Text(
                                                        'Bạn có chắc chắn muốn xóa sản phẩm này không?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('Hủy'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text('Đồng ý'),
                                                        onPressed: () {
                                                          Product add = Product(
                                                              product_id:
                                                                  productListByAdmin[
                                                                          index]
                                                                      [
                                                                      'product_id'],
                                                              name: "",
                                                              image: "",
                                                              price: "",
                                                              category_id: "",
                                                              description: "",
                                                              status: "");
                                                          productDelete(add);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.restore_from_trash),
                                          ),
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

  Future productDelete(Product pro) async {
    final uri = Uri.parse('http://192.168.1.5/flutter/deleteProduct.php');
    var request = http.MultipartRequest('POST', uri);

    request.fields['product_id'] = pro.product_id;

    var response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa sản phẩm thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa sản phẩm')),
      );
    }
  }

  Future<List> loadProductByAdmin() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.5/flutter/loadProductByAdmin.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Load thất bại');
    }
  }
}

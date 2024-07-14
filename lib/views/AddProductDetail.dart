import 'dart:convert';

import 'package:app_203store/models/ProductDetail.dart';
import 'package:app_203store/views/ProductsManagerScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddProductDetailScreen extends StatefulWidget {
  AddProductDetailScreen({super.key, required this.product});
  final dynamic product;
  @override
  State<AddProductDetailScreen> createState() => _AddProductDetailScreenState();
}

class _AddProductDetailScreenState extends State<AddProductDetailScreen> {
  ProductDetail newPro = ProductDetail(
      pro_id: "",
      product_id: "",
      color_id: "",
      quantity: "",
      status: "",
      sell: "");

  String? color;
  List<dynamic> colorList = [];

  @override
  void initState() {
    super.initState();
    loadColors();
  }

  Future<void> loadColors() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.5/flutter/loadColor.php'));
    if (response.statusCode == 200) {
      setState(() {
        colorList = json.decode(response.body);
      });
    } else {
      throw Exception('Load thất bại');
    }
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
          title: const Text("Thêm chi tiết sản phẩm"),
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
                      "Màu sắc",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 62.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: colorList.isEmpty
                    ? CircularProgressIndicator()
                    : DropdownButtonFormField<String>(
                        value: color,
                        onChanged: (String? newValue) {
                          setState(() {
                            color = newValue;
                          });
                        },
                        items: colorList
                            .map<DropdownMenuItem<String>>((dynamic item) {
                          return DropdownMenuItem<String>(
                            value: item['color_id'].toString(),
                            child: Text(item['color_name']),
                          );
                        }).toList(),
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
                      ProductDetail add = ProductDetail(
                          pro_id: "",
                          product_id: widget.product['product_id'],
                          color_id: color!,
                          quantity: 0.toString(),
                          sell: 0.toString(),
                          status: 1.toString());
                      productDetailAdd(add);
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(180, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Colors.lightBlue[200]),
                    child: const Text(
                      "Nhập",
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

  Future productDetailAdd(ProductDetail pro) async {
    final uri = Uri.parse('http://192.168.1.5/flutter/addProductDetail.php');
    var request = http.MultipartRequest('POST', uri);
    request.fields['product_id'] = pro.product_id;
    request.fields['color_id'] = pro.color_id;
    request.fields['quantity'] = pro.quantity;
    request.fields['status'] = 1.toString();
    request.fields['sell'] = pro.sell;

    var response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final message = jsonDecode(res.body)['message'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      Navigator.pop(context);
    } else {
      throw Exception('Lỗi thêm mặt hàng');
    }
  }
}

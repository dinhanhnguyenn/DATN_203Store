import 'dart:convert';

import 'package:app_203store/models/ProductDetail.dart';
import 'package:app_203store/views/ProductsManagerScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InputProductDetail extends StatefulWidget {
  InputProductDetail({super.key, required  this.product});
  final dynamic product;
  @override
  State<InputProductDetail> createState() => _InputProductDetailState();
}

class _InputProductDetailState extends State<InputProductDetail> {
  ProductDetail addPro = ProductDetail(
      pro_id: "", product_id: "", color_id: "", quantity: "", status: "", sell: "");

  var soluong = TextEditingController();

  String? color;
  List<dynamic> colorList = [];

  @override
  void initState() {
    super.initState();
    loadColors();
  }

  Future<void> loadColors() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.6/flutter/loadColorByProductDetail.php?id=${widget.product["product_id"]}'));
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
            Column(mainAxisAlignment: MainAxisAlignment.center, 
              children: [
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Màu sắc",
                      style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Số lượng",
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
                controller: soluong,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  prefixIcon: const Icon(Icons.numbers_rounded),
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
                      print(widget.product['product_id']);
                      print(color!);
                      inputProduct(widget.product['product_id'],color!,soluong.text);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(180, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Colors.lightBlue[200]
                    ),
                    child: const Text(
                      "Nhập",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              )
            ]
          ),
        ),
      )
    );
  }

  Future<void> inputProduct(String product_id, String color_id, String quantity) async {
  final uri = Uri.parse('http://192.168.1.6/flutter/updateProductDetail.php');
  var request = http.MultipartRequest('POST', uri);

    request.fields['product_id'] = product_id;
    request.fields['color_id'] = color_id;
    request.fields['quantity'] = quantity;

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nhập sản phẩm thành công')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi nhập sản phẩm')),
      );
    }
  }
}



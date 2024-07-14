import 'dart:convert';

import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/Cart_Page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class InfoProduct extends StatefulWidget {
  InfoProduct({Key? key, required this.product}) : super(key: key);
  final dynamic product;

  @override
  State<InfoProduct> createState() => _InfoProductState();
}

class _InfoProductState extends State<InfoProduct> {
  List<Map<String, dynamic>> colors = [];

  var formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

  Future<void> loadColors() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.5/flutter/loadColorByProductDetail.php?id=${widget.product["product_id"]}'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        colors = data
          .map((item) => {
                'color_id': item['color_id'],
                'color_name': item['color_name'],
                'quantity': item['quantity'] ?? 0,
              })
          .toList();
      });
    } else {
      throw Exception('Load thất bại');
    }
  }

  @override
  void initState() {
    super.initState();
    loadColors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông tin sản phẩm",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlue[200],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      "http://192.168.1.5/flutter/uploads/${widget.product["image"]}",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.product["name"]}',
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '${formatCurrency.format(double.parse(widget.product["price"].toString()))}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Thông tin hàng hóa',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 17.0
                        )
                      ),
                      InkWell(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 2,
                            ),
                            itemCount: colors.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final color = colors[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0
                                  )
                                ), 
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        color['color_name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        'Kho: ${color['quantity']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  )
                              )
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Text('Mô tả sản phẩm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 15.0
                        )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0XFFD9D9D9),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${widget.product["description"]}')
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:app_203store/models/Product.dart';
import 'package:app_203store/views/Cart_Page.dart';
import 'package:app_203store/views/Payment_Page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailProduct extends StatefulWidget {
   DetailProduct({super.key, required this.product});
   var product;
  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {

  List<String> colors = [];
  Future<void> loadColors() async {
    final response = await http.get(Uri.parse('http://192.168.1.15/flutter/loadColorByProductDetail.php?id=${widget.product["product_id"]}'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        colors = data.map((item) => item['color_name'] as String).toList();
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(
          Icons.phone_in_talk, 
          color: Colors.white
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MaterialButton(
              color: const Color(0xFF8E8E8E),
              onPressed: () {
                Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Cart()));
              },
              child: Container(
                alignment: Alignment.center,
                height: 70,
                child: const Center(
                  child: Text(
                    'Thêm vào giỏ hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                )
              ),
            ),
          ),
          Expanded(
            child: MaterialButton(
              color: Colors.red,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Payment()));
              },
              child: Container(
                alignment: Alignment.center,
                height: 70,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'MUA NGAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                      ),
                    ),
                    Text(
                      'Giao tận nơi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                       "http://192.168.1.15/flutter/uploads/${widget.product["image"]}",
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8.0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      )
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
                         ' ${widget.product["price"]} VND',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text('Màu sắc',
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
                            childAspectRatio: 2.5,
                          ),
                          itemCount: colors.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Card(
                                color: const Color(0xFFD9D9D9),
                                child: Center(
                                  child: 
                                  Text(
                                    colors[index]
                                  )
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
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.product["description"]}'
                                )
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 20.0,
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

  Future<List> loadProduct() async {
    final response = await http.get(Uri.parse('http://192.168.1.15/flutter/loadColorByProductDetail.php?product_id=${widget.product["product_id"]}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Load thất bại');
    }
  }
}
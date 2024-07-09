import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailOrderUser extends StatefulWidget {
  final int order_id;
  const DetailOrderUser({Key? key, required this.order_id}) : super(key: key);

  @override
  State<DetailOrderUser> createState() => _DetailOrderUserState();
}

class _DetailOrderUserState extends State<DetailOrderUser> {
  List<dynamic> detailOrder = [];

  @override
  void initState() {
    super.initState();
    fetchDetailOrder();
  }

  Future<void> fetchDetailOrder() async {
    final int order_id = widget.order_id;
    if (order_id == null) {
      throw Exception('Order ID is null or invalid');
    }

    final response = await http.get(Uri.parse(
        'http://192.168.30.35/flutter/load_detail_order_user.php?order_id=$order_id'));
    if (response.statusCode == 200) {
      setState(() {
        detailOrder = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<List<dynamic>> loadProductDetails(int productId) async {
    final parsedProductId = int.tryParse(productId.toString());
    if (parsedProductId == null) {
      return []; // Return empty list if productId is not valid
    }

    final response = await http.get(Uri.parse(
        'http://192.168.30.35/flutter/loadProductId.php?product_id=$parsedProductId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  // Future<List<dynamic>> loadUser(int userId) async {
  //   final parsedUserId = int.tryParse(userId.toString());
  //   if (parsedUserId == null) {
  //     return []; // Return empty list if userId is not valid
  //   }

  //   final response = await http.get(Uri.parse(
  //       'http://192.168.30.35/flutter/get_user_info.php?user_id=$parsedUserId'));
  //   if (response.statusCode == 200) {
  //     return [
  //       json.decode(response.body)
  //     ]; // Wrap result in list for consistency
  //   } else {
  //     throw Exception('Failed to load user details');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đơn Hàng ${widget.order_id}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: detailOrder.length,
              itemBuilder: (context, index) {
                // Ensure productId is correctly parsed to int
                // int userid =
                //     int.parse(detailOrder[index]['user_id'].toString()) ?? 0;
                int productId =
                    int.tryParse(detailOrder[index]["product_id"].toString()) ??
                        0;

                return FutureBuilder(
                  future: loadProductDetails(productId),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('Product not found');
                    } else {
                      var product = snapshot.data![0];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Tên sản phẩm: ${product["name"]}'),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text('Giá: ${product["price"]}'),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                    'Số lượng: ${detailOrder[index]["quantity"]}'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

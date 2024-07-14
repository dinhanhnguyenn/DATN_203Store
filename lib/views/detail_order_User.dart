import 'dart:convert';
import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/ReviewOrder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DetailOrderUser extends StatefulWidget {
  final int order_id;
  final String status;
  const DetailOrderUser(
      {Key? key, required this.order_id, required this.status})
      : super(key: key);

  @override
  State<DetailOrderUser> createState() => _DetailOrderUserState();
}

class _DetailOrderUserState extends State<DetailOrderUser> {
  Map<String, dynamic> userDetails = {};
  List<Map<String, dynamic>> orderDetails = [];
  List<Map<String, dynamic>> productDetails = [];
  bool isLoading = true;
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserProvider>(context, listen: false).userId;
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    await Future.wait([fetchUserDetails(), fetchOrderDetails()]);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchUserDetails() async {
    final int order_id = widget.order_id;

    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.5/flutter/load_order_user_details.php?order_id=$order_id'));

      if (response.statusCode == 200) {
        setState(() {
          userDetails = json.decode(response.body) as Map<String, dynamic>;
          print(userDetails);
        });
      } else {
        throw Exception('Failed to load user details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
      // Handle error (e.g., display error message to user)
    }
  }

  Future<void> fetchOrderDetails() async {
    int order_id = widget.order_id;

    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.5/flutter/get_order_details.php?order_id=$order_id'));

      if (response.statusCode == 200) {
        List<dynamic> orderDetailsList = json.decode(response.body);
        List<Map<String, dynamic>> castedOrderDetails = orderDetailsList
            .map((item) => item as Map<String, dynamic>)
            .toList();

        List<Map<String, dynamic>> productList = [];

        for (var orderDetail in castedOrderDetails) {
          int pro_id = int.parse(orderDetail['pro_id'].toString());
          var productName = await fetchProductName(pro_id);
          var colorName = await fetchColorDetails(pro_id);
          productList.add({
            'pro_id': pro_id,
            'product_name': productName,
            'color_name': colorName,
          });
        }

        setState(() {
          orderDetails = castedOrderDetails;
          productDetails = productList;
        });
      } else {
        throw Exception('Failed to load order details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching order details: $e');
      // Handle error
    }
  }

  Future<String> fetchColorDetails(int pro_id) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.5/flutter/get_color_name.php?pro_id=$pro_id'));

      if (response.statusCode == 200) {
        List<dynamic> colorDetailsList = json.decode(response.body);
        if (colorDetailsList.isNotEmpty) {
          return colorDetailsList.first['color_name'];
        } else {
          return 'Unknown';
        }
      } else {
        throw Exception('Failed to load color details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching color details: $e');
      return 'Unknown';
    }
  }

  Future<String> fetchProductName(int pro_id) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.5/flutter/get_name_product.php?pro_id=$pro_id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['name'];
      } else {
        throw Exception('Failed to load product name: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product name: $e');
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đơn Hàng ${widget.order_id}"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: orderDetails.length,
                    itemBuilder: (context, index) {
                      var orderDetail = orderDetails[index];
                      var pro_id = int.parse(orderDetail['pro_id'].toString());
                      var productDetail = productDetails.firstWhere(
                          (product) => product['pro_id'] == pro_id,
                          orElse: () => {
                                'product_name': 'Unknown',
                                'color_name': 'Unknown'
                              });

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Tên sản phẩm: ${productDetail["product_name"]}'),
                              SizedBox(height: 5),
                              Text('Màu sắc: ${productDetail["color_name"]}'),
                              SizedBox(height: 5),
                              Text('Giá: ${orderDetail["price"]}'),
                              SizedBox(height: 5),
                              Text('Số lượng: ${orderDetail["quantity"]}'),
                              SizedBox(height: 5),
                              if (widget.status == 'Đã Giao')
                                ElevatedButton(
                                  onPressed: () {
                                    print(orderDetail['pro_id']);
                                    print(userId);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReviewOrder(
                                          user_id: userId,
                                          pro_id: int.parse(
                                              orderDetail['pro_id'].toString()),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Đánh Giá'),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

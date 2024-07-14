import 'dart:convert';
import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/InvoiceScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<dynamic> _cartItems = [];
  double _totalPrice = 0.0;
  var Nameproduct;

  @override
  void initState() {
    super.initState();
    int userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId != null) {
      fetchCartItems(userId).then((data) {
        setState(() {
          _cartItems = data;
          _calculateTotalPrice();
        });
      });
    }
  }

  Future<List<dynamic>> fetchCartItems(int userId) async {
    final String apiUrl = 'http://192.168.1.6/flutter/load_cart_items.php';

    try {
      final response = await http.get(Uri.parse('$apiUrl?user_id=$userId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Sử dụng Future.wait để chờ tất cả các chi tiết sản phẩm được lấy
        await Future.wait(data.map((item) async {
          String? productName =
              await fetchData(int.parse(item['pro_id'].toString()));
          item['name'] =
              productName; // Cập nhật tên sản phẩm vào danh sách _cartItems
          int proId = int.parse(item['pro_id'].toString());
          var productDetails = await fetchProductDetails(proId);
          if (productDetails != null) {
            item['color_name'] = productDetails['color_name'];
          }
        }).toList());

        return data;
      } else {
        print('Failed to load cart items: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading cart items: $e');
      return [];
    }
  }

  Future<dynamic> fetchProductDetails(int proId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.6/flutter/get_product_details.php?pro_id=$proId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return data; // Return the fetched data
    } else {
      throw Exception('Failed to load product details');
    }
  }

  void _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in _cartItems) {
      double? itemPrice = double.tryParse(item['price'].toString());
      int? itemQuantity = int.tryParse(item['quantity'].toString());

      if (itemPrice != null && itemQuantity != null) {
        totalPrice += itemPrice * itemQuantity;
      }
    }
    setState(() {
      _totalPrice = totalPrice;
    });
  }

  Future<void> _deleteItemCart(String cartDetailId) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.6/flutter/update_status.php'),
      body: {'cartz_detail_id': cartDetailId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _cartItems
              .removeWhere((item) => item['cartz_detail_id'] == cartDetailId);
          _calculateTotalPrice();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa thất bại: ${data['message']}')),
        );
      }
    } else {
      print('Failed to delete item with status code: ${response.statusCode}');
      throw Exception('Failed to delete order');
    }
  }

  Future<void> _updateQuantity(String cartDetailId, int newQuantity) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.6/flutter/update_quantity.php'),
      body: {
        'cartz_detail_id': cartDetailId,
        'new_quantity': newQuantity.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _cartItems.firstWhere((item) =>
                  item['cartz_detail_id'] == cartDetailId)['quantity'] =
              newQuantity;
          _calculateTotalPrice();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật số lượng thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thất bại: ${data['message']}')),
        );
      }
    } else {
      print(
          'Failed to update quantity with status code: ${response.statusCode}');
      throw Exception('Failed to update quantity');
    }
  }

  Future<String?> fetchData(int proId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.6/flutter/get_product_info.php?pro_id=$proId'));

    if (response.statusCode == 200) {
      // Nếu kết nối thành công và có dữ liệu trả về
      List<dynamic> data = jsonDecode(response.body);

      // Xử lý dữ liệu ở đây, ví dụ:
      String? productName;
      for (var item in data) {
        print('Tên sản phẩm: ${item['name']}');
        productName = item['name'];
      }
      return productName;
    } else {
      // Nếu gặp lỗi khi gọi API
      print('Lỗi khi gọi API: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Giỏ Hàng"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                var item = _cartItems[index];
                String? colorName = item['color_name']?.toString();
                String? price = item['price']?.toString();
                int? quantity = item['quantity'] != null
                    ? int.tryParse(item['quantity'].toString())
                    : null;
                String? image = item['image']?.toString();
                String? cartDetailId = item['cartz_detail_id']?.toString();
                String? nameProduct = item['name']?.toString();

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        image != null
                            ? Image.network(
                                'http://192.168.1.6/flutter/uploads/$image',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            nameProduct != null
                                ? Text(
                                    '$nameProduct',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  )
                                : Container(),
                            colorName != null
                                ? Text(
                                    '$colorName',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  )
                                : Container(),
                            price != null
                                ? Text(
                                    '$price VNĐ',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  )
                                : Container(),
                            // Display color name if available
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      if (quantity != null && quantity > 1) {
                                        _updateQuantity(
                                            cartDetailId!, quantity - 1);
                                      }
                                    },
                                  ),
                                  SizedBox(width: 5),
                                  quantity != null
                                      ? Text(
                                          '$quantity',
                                          style: TextStyle(fontSize: 16),
                                        )
                                      : Container(),
                                  SizedBox(width: 5),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      if (cartDetailId != null &&
                                          quantity != null) {
                                        _updateQuantity(
                                            cartDetailId, quantity + 1);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (cartDetailId != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Xác nhận xóa"),
                                    content: Text(
                                        "Bạn có chắc muốn xóa mục này không?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Hủy"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Xóa"),
                                        onPressed: () {
                                          _deleteItemCart(cartDetailId);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Text(
                  'Tổng cộng: $_totalPrice VNĐ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 40,
                    ),
                    backgroundColor: Colors.lightBlue[200],
                  ),
                  onPressed: () {
                    if (_cartItems.isNotEmpty && _totalPrice > 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoiceScreen(
                            total: _totalPrice,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Không có mặt hàng trong giỏ hàng!'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Mua Hàng",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:app_203store/models/CartProdvider.dart';
import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/Payment_Page.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    final idCart = Provider.of<CartProvider>(context, listen: false).idCart;
    final response = await http.post(
      Uri.parse('http://192.168.1.5/flutter/loadDetail_Cart.php'),
      body: {'id_cart': idCart.toString()},
    );

    if (response.statusCode == 200) {
      try {
        final List<dynamic> items = jsonDecode(response.body);
        setState(() {
          _cartItems = items.map((item) {
            return {
              'cartz_detail_id': item['cartz_detail_id'].toString(),
              'image': item['image'].toString(),
              'price': item['price'].toString(),
              'quantity': int.parse(item['quantity'].toString()),
              'product_id': int.parse(item['product_id'].toString()),
              'id_color': int.parse(item['id_color']).toString()
            };
          }).toList();
          _calculateTotalPrice();
        });
      } catch (e) {
        print("Error parsing JSON: $e");
      }
    } else {
      print(
          'Failed to load cart items with status code: ${response.statusCode}');
      throw Exception('Failed to load cart items');
    }
  }

  void _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in _cartItems) {
      totalPrice += double.parse(item['price']) * item['quantity'];
    }
    setState(() {
      _totalPrice = totalPrice;
    });
  }

  Future<void> _deleteItemCart(String cartDetailId) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.5/flutter/update_status.php'),
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Xóa đơn hàng thành công')),
        // );
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
      Uri.parse('http://192.168.1.5/flutter/update_quantity.php'),
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Cập nhật số lượng thành công')),
        // );
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

  Future<void> _createOrder() async {
    int userId = Provider.of<UserProvider>(context, listen: false).userId;
    double totalPrice = _totalPrice;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.5/flutter/addOrder.php'),
        body: {
          'user_id': userId.toString(),
          'total': totalPrice.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          int orderId = data['order_id'];

          // Gọi API để thêm chi tiết đơn hàng
          for (var item in _cartItems) {
            await http.post(
              Uri.parse('http://192.168.1.5/flutter/addDetailOrder.php'),
              body: {
                'order_id': orderId.toString(),
                'product_id': item['product_id'].toString(),
                'quantity': item['quantity'].toString(),
                'id_color': item['id_color'].toString()
              },
            );
            _deleteItemCart(item['cartz_detail_id']);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Payment(
                      order_id: orderId,
                      total: totalPrice,
                    )),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${data['message']}')),
          );
        }
      } else {
        print(
            'Failed to create order with status code: ${response.statusCode}');
        throw Exception('Failed to create order');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi không xác định')),
      );
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
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Image.network(
                          'http://192.168.1.5/flutter/uploads/${item['image']}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 5),
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
                                      if (item['quantity'] > 1) {
                                        _updateQuantity(item['cartz_detail_id'],
                                            item['quantity'] - 1);
                                      }
                                    },
                                  ),
                                  Text(
                                    '${item['quantity']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      _updateQuantity(item['cartz_detail_id'],
                                          item['quantity'] + 1);
                                    },
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      ' Gía ${item['price']} VNĐ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteItemCart(item['cartz_detail_id']);
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
                      _createOrder();
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

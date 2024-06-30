import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final response = await http
        .get(Uri.parse('http://192.168.30.103/flutter/loadDetail_Order.php'));

    if (response.statusCode == 200) {
      print(response.body); // In ra nội dung phản hồi để kiểm tra
      try {
        final List<dynamic> items = jsonDecode(response.body);
        setState(() {
          _cartItems = items.map((item) {
            return {
              'order_detail_id': item['order_detail_id'].toString(),
              'image': item['image'].toString(),
              'price': item['price'].toString(),
              'quantity': int.parse(item['quantity'].toString()),
            };
          }).toList();
          _calculateTotalPrice();
        });
      } catch (e) {
        print("Error parsing JSON: $e");
      }
    } else {
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

  Future<void> _deleteOrder(String orderDetailId) async {
    final response = await http.post(
      Uri.parse('http://192.168.30.103/flutter/update_status.php'),
      body: {'order_detail_id': orderDetailId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _cartItems
              .removeWhere((item) => item['order_detail_id'] == orderDetailId);
          _calculateTotalPrice();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa đơn hàng thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa thất bại: ${data['message']}')),
        );
      }
    } else {
      throw Exception('Failed to delete order');
    }
  }

  Future<void> _updateQuantity(String orderDetailId, int newQuantity) async {
    print('Updating quantity: $orderDetailId, $newQuantity');
    final response = await http.post(
      Uri.parse('http://192.168.30.103/flutter/update_quantity.php'),
      body: {
        'order_detail_id': orderDetailId,
        'new_quantity': newQuantity.toString(),
      },
    );

    print(response.body); // Thêm dòng này để kiểm tra phản hồi

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _cartItems.firstWhere((item) =>
                  item['order_detail_id'] == orderDetailId)['quantity'] =
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
      throw Exception('Failed to update quantity');
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
                return ListTile(
                  leading: Image.network(
                    'http://192.168.30.103/flutter/uploads/${item['image']}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item['order_detail_id'].toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (item['quantity'] > 1) {
                                _updateQuantity(
                                    item['order_detail_id'].toString(),
                                    item['quantity'] - 1);
                              }
                            },
                          ),
                          Text('Số lượng: ${item['quantity']}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _updateQuantity(
                                  item['order_detail_id'].toString(),
                                  item['quantity'] + 1);
                            },
                          ),
                        ],
                      ),
                      Text('Giá: ${item['price']} VND'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Xóa đơn hàng"),
                            content:
                                Text("Bạn có chắc chắn muốn xóa đơn hàng này?"),
                            actions: [
                              TextButton(
                                child: Text("Hủy"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Xóa"),
                                onPressed: () {
                                  _deleteOrder(
                                      item['order_detail_id'].toString());
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              Text(
                'Tổng tiền: $_totalPrice VND',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Tiếp Tục'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.lightBlue[200],
                  padding: EdgeInsets.symmetric(
                      vertical: 16, horizontal: 24), // Kích thước của nút
                  textStyle:
                      TextStyle(fontSize: 18), // Kiểu chữ của văn bản nút
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Độ bo tròn các góc của nút
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

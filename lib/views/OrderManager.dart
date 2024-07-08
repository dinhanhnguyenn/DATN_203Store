import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageOrdersPage extends StatefulWidget {
  @override
  _ManageOrdersPageState createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  List<dynamic> orders = [];
  List<String> statusOptions = ['pending', 'shipped', 'delivered', 'cancelled'];
  List<String> paymentStatusOptions = ['Paid', 'Not yet paid'];

  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.9/flutter/LoadOrderManager.php'));

      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
          print(orders);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load orders (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to connect to server: $e';
        isLoading = false;
      });
    }
  }

  void updateOrderStatus(
      int orderId, String newStatus, String newPaymentStatus) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.9/flutter/updateOrderStatus.php'),
        body: {
          'order_id': orderId.toString(),
          'status': newStatus,
          'status2': newPaymentStatus,
        },
      );

      if (response.statusCode == 200) {
        fetchOrders(); // Refresh the orders list
      } else {
        setState(() {
          errorMessage = 'Failed to update order (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to connect to server: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản Lí Đơn Hàng"),
      ),
      body: Column(
        children: [
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (errorMessage.isNotEmpty)
            Center(child: Text(errorMessage))
          else
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  String selectedStatus = order['status'];
                  String selectedPaymentStatus = order['status2'];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mã Đơn Hàng: ${order['order_id']}'),
                          SizedBox(
                            height: 5,
                          ), // Hiển thị dưới dạng String
                          Text('Ngày Đặt Hàng: ${order['order_date']}'),
                          Row(
                            children: [
                              Text('Trạng Thái Đơn Hàng : '),
                              DropdownButton<String>(
                                value: selectedStatus,
                                items: statusOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedStatus = newValue;
                                    });
                                    updateOrderStatus(
                                        int.parse(order['order_id']
                                            .toString()), // Chuyển đổi sang int
                                        newValue,
                                        selectedPaymentStatus);
                                  }
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Trạng Thái Thanh Toán : '),
                              DropdownButton<String>(
                                value: selectedPaymentStatus,
                                items: paymentStatusOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedPaymentStatus = newValue;
                                    });
                                    updateOrderStatus(
                                        int.parse(order['order_id']
                                            .toString()), // Chuyển đổi sang int
                                        selectedStatus,
                                        newValue);
                                  }
                                },
                              ),
                            ],
                          ),
                          Text('Tổng Tiền: ${order['total']}'),
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

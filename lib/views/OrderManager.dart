import 'package:app_203store/views/DetailOderManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageOrdersPage extends StatefulWidget {
  @override
  _ManageOrdersPageState createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> orders = [];
  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.5/flutter/LoadOrderManager.php'));

      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
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
      print(
          'Updating order: order_id=$orderId, status=$newStatus, status2=$newPaymentStatus');

      final response = await http.post(
        Uri.parse('http://192.168.1.5/flutter/updateOrderStatus.php'),
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

  List<dynamic> getOrdersByStatus(String status) {
    return orders.where((order) => order['status'] == status).toList();
  }

  Widget buildOrderList(List<dynamic> filteredOrders) {
    if (filteredOrders.isEmpty) {
      return Center(child: Text('Không có đơn hàng'));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        String selectedStatus = order['status'];
        String selectedPaymentStatus = order['status2'];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailOrderManager(
                  status: order['status'],
                  order_id: int.parse(order['order_id']),
                ),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mã Đơn Hàng: ${order['order_id']}'),
                  SizedBox(height: 5),
                  Text('Ngày Đặt Hàng: ${order['order_date']}'),
                  Row(
                    children: [
                      Text('Trạng Thái Đơn Hàng : '),
                      DropdownButton<String>(
                        value: selectedStatus,
                        items: ['Đang chờ', 'Vận Chuyển', 'Đã Giao', 'Đã Hủy']
                            .map((String value) {
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
                                int.parse(order['order_id'].toString()),
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
                        items: ['Thanh Toán', 'Chưa Thanh Toán']
                            .map((String value) {
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
                                int.parse(order['order_id'].toString()),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Quản Lí Đơn Hàng"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.pending_actions), text: 'Đang Chờ'),
            Tab(icon: Icon(Icons.local_shipping), text: 'Vận Tải'),
            Tab(icon: Icon(Icons.done_all), text: 'Đã Giao'),
            Tab(icon: Icon(Icons.cancel), text: 'Đã Hủy'),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    buildOrderList(getOrdersByStatus('Đang chờ')),
                    buildOrderList(getOrdersByStatus('Vận Chuyển')),
                    buildOrderList(getOrdersByStatus('Đã Giao')),
                    buildOrderList(getOrdersByStatus('Đã Hủy')),
                  ],
                ),
    );
  }
}

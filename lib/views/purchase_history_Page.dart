import 'dart:convert';
import 'package:app_203store/views/MainScreen.dart';
import 'package:app_203store/views/detail_order_User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PurchaseHistory extends StatefulWidget {
  final int user_id;
  const PurchaseHistory({Key? key, required this.user_id}) : super(key: key);

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> orders = [];
  bool isLoading = false;
  String errorMessage = '';

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
      final response = await http.get(Uri.parse(
          'http://192.168.1.5/flutter/loadorderUser.php?user_id=${widget.user_id}'));

      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load orders';
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

  Future<void> cancelOrder(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.5/flutter/updateOrderStatus.php'),
        body: {
          'order_id': orderId.toString(),
          'status': 'Đã Hủy',
          'status2': 'Chưa Thanh Toán'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          // Cập nhật lại danh sách đơn hàng sau khi hủy đơn
          fetchOrders();
        });
      } else {
        setState(() {
          errorMessage = 'Failed to cancel order (${response.statusCode})';
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
        bool isPending = order['status'] == 'Đang chờ';

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailOrderUser(
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
                  Text('Trạng Thái: ${order['status']}'),
                  Text('Thanh Toán: ${order['status2']}'),
                  Text('Tổng Tiền: ${order['total']}'),
                  if (isPending) ...[
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Xác nhận trước khi hủy đơn
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Xác nhận hủy đơn hàng'),
                              content: Text(
                                  'Bạn có chắc chắn muốn hủy đơn hàng này không?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Hủy'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Đồng ý'),
                                  onPressed: () {
                                    cancelOrder(int.parse(order['order_id']));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Hủy Đơn Hàng'),
                    ),
                  ],
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            }),
        title: Text("Lịch sử mua hàng"),
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

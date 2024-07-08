import 'dart:convert';

import 'package:app_203store/views/detail_order_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class PurchaseHistory extends StatefulWidget {
  final int user_id;
  const PurchaseHistory({Key? key, required this.user_id}) : super(key: key);

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse(
        'http://192.168.30.103/flutter/loadorderUser.php?user_id=${widget.user_id}'));

    if (response.statusCode == 200) {
      setState(() {
        orders = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch Sử Mua Hàng"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailOrderUser(
                          order_id: int.parse(orders[index]['order_id']),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Mã Đơn Hàng: ${orders[index]['order_id']}',
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Ngày Đặt Hàng: ${orders[index]['order_date']}',
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Trạng Thái: ${orders[index]['status']}',
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Thanh Toán: ${orders[index]['status2']}',
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Tổng Tiền: ${orders[index]['total']}',
                            ),
                          ),
                        ],
                      ),
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

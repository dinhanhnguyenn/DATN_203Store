import 'package:app_203store/models/UserInfo.dart';
import 'package:flutter/material.dart';

class InvoiceScreen extends StatefulWidget {
  final int order_id;
  const InvoiceScreen({Key? key, required this.order_id}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  late Future<UserInfo?> _userInfoFuture;
  late Future<int?> _totalQuantityFuture;
  late Future<double?> _totalAmountFuture;
  late Future<List<Map<String, dynamic>>?> _productsFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = getUserInfo(widget.order_id);
    _totalQuantityFuture = getTotalQuantity(widget.order_id);
    _totalAmountFuture = getTotalAmount(widget.order_id);
    _productsFuture = getProducts(widget.order_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: Future.wait([
            _userInfoFuture,
            _totalQuantityFuture,
            _totalAmountFuture,
            _productsFuture
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data found'));
            } else {
              // Lấy dữ liệu từ snapshot
              UserInfo? userInfo = snapshot.data![0];
              int? totalQuantity = snapshot.data![1];
              double? totalAmount = snapshot.data![2];
              List<Map<String, dynamic>>? products = snapshot.data![3];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${widget.order_id}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Customer: ${userInfo!.fullName}'),
                  Text('Phone: ${userInfo.phone}'),
                  Text('Address: ${userInfo.address}'),
                  SizedBox(height: 20),
                  Text(
                    'Products:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(products[index]['name']),
                        subtitle: Text('Price: ${products[index]['price']}'),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Total Quantity: $totalQuantity'),
                  Text('Total Amount: $totalAmount'),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

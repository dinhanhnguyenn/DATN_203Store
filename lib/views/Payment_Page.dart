import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:app_203store/models/UserProvider.dart';

class Payment extends StatefulWidget {
  final int order_id;
  final double total;

  const Payment({Key? key, required this.order_id, required this.total})
      : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String _paymentMethod = 'zalopay'; // Chọn phương thức thanh toán ZaloPay

  void _onPaymentMethodChanged(String? value) {
    setState(() {
      _paymentMethod = value!;
    });
  }

  Future<void> _createZaloPayPayment(int orderId) async {
    final url =
        'http://192.168.1.9/flutter/onlinepayment.php'; // Địa chỉ API PHP của bạn

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'partnerCode': 'YOUR_ZALOPAY_PARTNER_CODE',
          'accessKey': 'YOUR_ZALOPAY_ACCESS_KEY',
          'secretKey': 'YOUR_ZALOPAY_SECRET_KEY',
          'orderId': orderId.toString(),
          'orderInfo': 'Thanh toán qua ZaloPay',
          'amount': widget.total.toString(),
          'ipnUrl': 'https://webhook.site/b3088a6a-2d17-4f8d-a383-71389a6c600b',
          'redirectUrl':
              'https://webhook.site/b3088a6a-2d17-4f8d-a383-71389a6c600b',
          'extraData': '',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['payUrl'] != null) {
          _launchURL(jsonResponse['payUrl']);
        } else {
          print('Error creating transaction: ${jsonResponse['message']}');
        }
      } else {
        print('Failed to create transaction.');
      }
    } catch (e) {
      print('Error: $e');
      // Xử lý lỗi nếu gặp phải
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<UserProvider>(context).userId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: Text(
          'Thanh Toán',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Chọn phương thức thanh toán',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('ZaloPay'),
                leading: Radio<String>(
                  value: 'zalopay',
                  groupValue: _paymentMethod,
                  onChanged: _onPaymentMethodChanged,
                ),
                trailing: Image.asset('assets/ZaloPay_logo.png',
                    width: 50), // Thay đổi hình ảnh logo ZaloPay của bạn
              ),
              ListTile(
                title: Text('Thanh toán khi nhận hàng'),
                leading: Radio<String>(
                  value: 'cash_on_delivery',
                  groupValue: _paymentMethod,
                  onChanged: _onPaymentMethodChanged,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_paymentMethod == 'zalopay') {
                    _createZaloPayPayment(widget.order_id);
                  } else {
                    // Xử lý logic thanh toán khi nhận hàng
                  }
                },
                child: Text('Thanh Toán'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

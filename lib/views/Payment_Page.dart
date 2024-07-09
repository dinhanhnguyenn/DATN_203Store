import 'dart:convert';
import 'package:app_203store/views/InvoiceScreen.dart';
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
  String _paymentMethod = 'e_wallet';

  void _onPaymentMethodChanged(String? value) {
    setState(() {
      _paymentMethod = value!;
    });
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
                title: Text('Ví điện tử'),
                leading: Radio<String>(
                  value: 'e_wallet',
                  groupValue: _paymentMethod,
                  onChanged: _onPaymentMethodChanged,
                ),
                trailing: Image.asset('assets/Momo.jpg', width: 50),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InvoiceScreen(
                              order_id: widget.order_id,
                            )),
                  );
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

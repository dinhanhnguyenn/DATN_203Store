import 'package:app_203store/models/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<UserProvider>(context).userId;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title:
            Text('Thanh Toán', style: TextStyle(fontWeight: FontWeight.bold)),
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
              SizedBox(
                height: 16,
              ),
              ListTile(
                title: Text('Ví điện tử'),
                leading: Radio(
                  value: 'e_wallet',
                  groupValue: 'payment_method',
                  onChanged: (value) {},
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/Momo.jpg', width: 50),
                  ],
                ),
              ),
              ListTile(
                title: Text('Thanh toán khi nhận hàng'),
                leading: Radio(
                  value: 'cash_on_delivery',
                  groupValue: 'payment_method',
                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 600,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Thanh Toán'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

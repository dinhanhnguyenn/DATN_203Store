import 'dart:convert';
import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/models/cardpay.dart';
import 'package:app_203store/views/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class InvoiceScreen extends StatefulWidget {
  final double total;

  const InvoiceScreen({super.key, required this.total});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  Map<String, dynamic>? paymentIntent;
  List<dynamic> _cartItems = [];
  var Nameproduct;
  late int userId;
  String email = '';
  String fullName = '';
  String address = '';
  String phone = '';
  String _paymentMethod = 'e_wallet'; // State variable for payment method
 Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('100000', 'VND');

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "VN", currencyCode: "VND", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Abhi',
                  googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51PcUEvRrmOJmSsuHO91sRAaI8dhIZkr07FzzELIg6tH8cs65uZgU6WTFoOtyNURPofKZWQNzaGFKkohiSCVVKzpI00aZTFWKsD',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> _getUserInfo() async {
    userId = Provider.of<UserProvider>(context, listen: false).userId;
    final response = await http.post(
      Uri.parse('http://192.168.1.5/flutter/get_user_info.php'),
      body: {'user_id': userId.toString()},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        if (mounted) {
          setState(() {
            email = jsonResponse['email'] ?? ' ';
            fullName = jsonResponse['full_name'] ?? ' ';
            address = jsonResponse['address'] ?? ' ';
            phone = jsonResponse['phone'] ?? ' ';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            email = ' ';
            fullName = ' ';
            address = ' ';
            phone = ' ';
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          email = ' ';
          fullName = ' ';
          address = ' ';
          phone = ' ';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    int userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId != null) {
      fetchCartItems(userId).then((data) {
        setState(() {
          _cartItems = data;
        });
      });
    }
    _getUserInfo();
  }

  Future<List<dynamic>> fetchCartItems(int userId) async {
    final String apiUrl = 'http://192.168.1.5/flutter/load_cart_items.php';

    try {
      final response = await http.get(Uri.parse('$apiUrl?user_id=$userId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Sử dụng Future.wait để chờ tất cả các chi tiết sản phẩm được lấy
        await Future.wait(data.map((item) async {
          String? productName =
              await fetchData(int.parse(item['pro_id'].toString()));
          item['name'] =
              productName; // Cập nhật tên sản phẩm vào danh sách _cartItems
          int proId = int.parse(item['pro_id'].toString());
          var productDetails = await fetchProductDetails(proId);
          if (productDetails != null) {
            item['color_name'] = productDetails['color_name'];
          }
        }).toList());

        return data;
      } else {
        print('Failed to load cart items: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading cart items: $e');
      return [];
    }
  }

  Future<String?> fetchData(int proId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.5/flutter/get_product_info.php?pro_id=$proId'));

    if (response.statusCode == 200) {
      // Nếu kết nối thành công và có dữ liệu trả về
      List<dynamic> data = jsonDecode(response.body);

      // Xử lý dữ liệu ở đây, ví dụ:
      String? productName;
      for (var item in data) {
        print('Tên sản phẩm: ${item['name']}');
        productName = item['name'];
      }
      return productName;
    } else {
      // Nếu gặp lỗi khi gọi API
      print('Lỗi khi gọi API: ${response.statusCode}');
      return null;
    }
  }

  Future<dynamic> fetchProductDetails(int proId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.5/flutter/get_product_details.php?pro_id=$proId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data; // Return the fetched data
    } else {
      throw Exception('Failed to load product details');
    }
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
          // Create a copy of _cartItems and modify the copy
          List<Map<String, dynamic>> updatedCartItems = List.from(_cartItems);
          updatedCartItems
              .removeWhere((item) => item['cartz_detail_id'] == cartDetailId);
          _cartItems = updatedCartItems;
        });
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

  Future<void> _createOrder() async {
    int userId = Provider.of<UserProvider>(context, listen: false).userId;
    double totalPrice = widget.total;

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
            if (item['quantity'] == null || item['cartz_detail_id'] == null) {
              print('Null value in _cartItems: $item');
              continue;
            }
            final detailResponse = await http.post(
              Uri.parse('http://192.168.1.5/flutter/addDetailOrder.php'),
              body: {
                'order_id': orderId.toString(),
                'pro_id': item['pro_id'].toString(),
                'quantity': item['quantity'].toString(),
                'price': item['price'].toString()
              },
            );

            if (detailResponse.statusCode == 200) {
              final detailData = jsonDecode(detailResponse.body);
              if (detailData['status'] == 'success') {
                _deleteItemCart(item['cartz_detail_id']);
              } else {
                print('Failed to add detail order: ${detailData['message']}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: ${detailData['message']}')),
                );
              }
            } else {
              print(
                  'Failed to add detail order with status code: ${detailResponse.statusCode}');
            }
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (Route<dynamic> route) =>
                false, // Đặt điều kiện để giữ các route khác
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
        title: Text("Chi Tiết Đơn Hàng"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: Colors.black,
              thickness: 5,
            ),
            Text(
              "Danh Sách Sản Phẩm",
              style: TextStyle(
                fontWeight: FontWeight.bold, // Example: Make the text bold
                fontSize: 18, // Example: Adjust font size
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  var item = _cartItems[index];
                  String? colorName = item['color_name']?.toString();
                  String? price = item['price']?.toString();
                  int? quantity = item['quantity'] != null
                      ? int.tryParse(item['quantity'].toString())
                      : null;
                  String? image = item['image']?.toString();
                  String? cartDetailId = item['cartz_detail_id']?.toString();
                  String? nameProduct = item['name']?.toString();
                  return CardPay(image: image, nameProduct: nameProduct, quantity: quantity, price: price, colorName: colorName);
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.black,
                  thickness: 5,
                ),
                SizedBox(
                  child: Text(
                    "Thông tin người nhận hàng",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold, // Example: Make the text bold
                      fontSize: 18, // Example: Adjust font size
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Tên: $fullName",
                  style: TextStyle(
                    fontSize: 16, // Adjust font size if needed
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Địa chỉ: $address",
                  style: TextStyle(
                    fontSize: 16, // Adjust font size if needed
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Số điện thoại: $phone",
                  style: TextStyle(
                    fontSize: 16, // Adjust font size if needed
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Email: $email",
                  style: TextStyle(
                    fontSize: 16, // Adjust font size if needed
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 5,
                ),
                SizedBox(
                  child: Text(
                    "Thanh Toán",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold, // Example: Make the text bold
                      fontSize: 18, // Example: Adjust font size
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Chọn phương thức thanh toán'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text('Ví điện tử'),
                                leading: Radio<String>(
                                  value: 'e_wallet',
                                  groupValue: _paymentMethod,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _paymentMethod = value!;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text('Thanh toán khi nhận hàng'),
                                leading: Radio<String>(
                                  value: 'cash_on_delivery',
                                  groupValue: _paymentMethod,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _paymentMethod = value!;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Phương Thức Thanh Toán'),
                ),
                Text(
                  'Tổng Tiền: ' + widget.total.toString(),
                  style: TextStyle(
                    fontSize: 16, // Adjust font size if needed
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  onPressed: ()async {
                  print(_paymentMethod);
                    if(_paymentMethod =="e_wallet"){
await makePayment();
                    }
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AlertDialog(
                    //       title: Text("Xác nhận Mua Hàng"),
                    //       content:
                    //           Text("Bạn có chắc mua các sản phẩm này không?"),
                    //       actions: <Widget>[
                    //         TextButton(
                    //           child: Text("Hủy"),
                    //           onPressed: () {
                    //             Navigator.of(context).pop();
                    //           },
                    //         ),
                    //         TextButton(
                    //           child: Text("Mua"),
                    //           onPressed: () {
                    //             _createOrder();
                    //             Navigator.of(context).pop();
                    //           },
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                  },
                  child: const Text(
                    "Mua Hàng",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
}

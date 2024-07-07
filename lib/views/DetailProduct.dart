import 'dart:convert';
import 'package:app_203store/models/CartProdvider.dart';
import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/Cart_Page.dart';
import 'package:app_203store/views/Payment_Page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DetailProduct extends StatefulWidget {
  DetailProduct({Key? key, required this.product}) : super(key: key);
  final Map<String, dynamic> product;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  final List<String> color = [
    'Vàng',
    'Xanh lá',
    'Đen',
    'Xanh lam',
    'Hồng',
  ];

  Future<void> addToCart() async {
    int userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == 0) {
      // Nếu userId = 0, yêu cầu người dùng đăng nhập
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập để thêm vào giỏ hàng')),
      );
      return;
    }
    int idCart = Provider.of<CartProvider>(context, listen: false).idCart;

    final url = Uri.parse('http://192.168.30.103/flutter/add_to_cart.php');
    try {
      final response = await http.post(url, body: {
        'product_id': widget.product['product_id'].toString(),
        'price': widget.product["price"].toString(),
        'quantity': '1',
        'id_cart': idCart.toString()
      });

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print(
            'Response body: $responseBody'); // Thêm dòng này để in nội dung phản hồi
        final data = json.decode(responseBody);
        if (data['status'] == 'success') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cart()),
          );
        } else if (data['status'] == 'exists') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sản phẩm đã có trong giỏ hàng')),
          );
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //       content: Text('Failed to add to cart: ${data['message']}')),
          // );
        }
      } else {
        print('Failed to load data with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to connect')),
      // );
    }
  }

  Future<void> _createOrder() async {
    int userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập để thêm vào giỏ hàng')),
      );
      return;
    }

    double totalPrice = double.parse(widget.product['price']);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.30.103/flutter/addOrder.php'),
        body: {
          'user_id': userId.toString(),
          'total': totalPrice.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          int orderId = data['order_id'];
          await http.post(
            Uri.parse('http://192.168.30.103/flutter/addDetailOrder.php'),
            body: {
              'order_id': orderId.toString(),
              'product_id': widget.product['product_id'].toString(),
              'quantity': '1',
            },
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Payment()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.phone_in_talk, color: Colors.white),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MaterialButton(
              color: const Color(0xFF8E8E8E),
              onPressed: addToCart,
              child: Container(
                alignment: Alignment.center,
                height: 70,
                child: const Center(
                  child: Text(
                    'Thêm vào giỏ hàng',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: MaterialButton(
              color: Colors.red,
              onPressed: _createOrder,
              child: Container(
                alignment: Alignment.center,
                height: 70,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'MUA NGAY',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    Text(
                      'Giao tận nơi',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    "http://192.168.30.103/flutter/uploads/${widget.product["image"]}",
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                      top: 8.0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.product["name"]}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      ' ${widget.product["price"]} VND',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text('Màu sắc',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0)),
                    InkWell(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: color.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {},
                              child: Card(
                                  color: const Color(0xFFD9D9D9),
                                  child: Center(
                                      child: Text(color[index].toString()))));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text('Mô tả sản phẩm',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0)),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0XFFD9D9D9),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${widget.product["description"]}')
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

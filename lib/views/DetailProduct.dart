import 'dart:convert';
import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/Cart_Page.dart';
import 'package:app_203store/views/Payment_Page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DetailProduct extends StatefulWidget {
  DetailProduct({Key? key, required this.product}) : super(key: key);
  final dynamic product;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  var colors = [];
  int? selectedID;
  var reviews = [];

  var formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

  int averageRating = 0; // Change to int for rounded average rating

  Future<void> loadColors() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.6/flutter/loadColorByProductDetail.php?id=${widget.product["product_id"]}'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        colors = data
            .map((item) => {
                  'color_id': item['color_id'],
                  'color_name': item['color_name'],
                  'quantity': item['quantity'] ?? 0
                })
            .toList();
      });
    } else {
      throw Exception('Load thất bại');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReviewsByProductId(int.parse(widget.product['product_id'].toString()));
    loadColors();
  }

  Future<int?> getProId(int productId) async {
    final url = Uri.parse('http://192.168.1.6/flutter/get_pro_id.php');
    try {
      final response = await http.post(url, body: {
        'product_id': productId.toString(),
      });

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final data = json.decode(responseBody);
        if (data['status'] == 'success') {
          return data['pro_id'];
        } else {
          print('Error: ${data['message']}');
          return null;
        }
      } else {
        print('Failed to load data with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> addToCart(bool isBuyingNow) async {
    int userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập để thêm vào giỏ hàng')),
      );
      return;
    }

    int? proId = await getProId(int.parse(widget.product['product_id']));
    print('id--------' + proId.toString());
    if (selectedID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Vui lòng chọn màu sắc trước khi thêm vào giỏ hàng')),
      );
      return;
    }

    final url = Uri.parse('http://192.168.1.6/flutter/add_to_cart.php');
    try {
      final response = await http.post(url, body: {
        'pro_id': proId.toString(),
        'user_id': userId.toString(),
        'price': widget.product["price"].toString(),
        'quantity': '1',
      });

      if (response.statusCode == 200) {
        final responseBody = response.body.trim(); // Xóa các khoảng trắng thừa
        print('Response body: $responseBody');

        // Kiểm tra và xử lý chuỗi JSON không hợp lệ
        if (responseBody.startsWith('<')) {
          throw Exception('Invalid JSON format');
        }

        final data = json.decode(responseBody);
        if (data['status'] == 'success') {
          if (isBuyingNow) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Payment(
                  total: double.parse(widget.product['price'].toString()),
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Cart()),
            );
          }
        } else if (data['status'] == 'exists') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sản phẩm đã có trong giỏ hàng')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã xảy ra lỗi, vui lòng thử lại sau')),
          );
        }
      } else {
        print('Failed to load data with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối, vui lòng thử lại sau')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết sản phẩm",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlue[200],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MaterialButton(
              color: const Color(0xFF8E8E8E),
              onPressed: () {
                addToCart(false);
              },
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
                  )),
            ),
          ),
          Expanded(
            child: MaterialButton(
              color: Colors.red,
              onPressed: () {
                addToCart(true);
              },
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
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      "http://192.168.1.6/flutter/uploads/${widget.product["image"]}",
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
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
                        '${formatCurrency.format(double.parse(widget.product["price"].toString()))}',
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
                            childAspectRatio: 2,
                          ),
                          itemCount: colors.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final color = colors[index];
                            return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedID = color['color_id'];
                                    print('id_color: ' + selectedID.toString());
                                  });
                                },
                                child: Card(
                                    color: selectedID == color['color_id']
                                        ? Colors.blue
                                        : null,
                                    child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              color['color_name'],
                                              style: TextStyle(
                                              fontWeight: FontWeight.bold),),
                                            Text(
                                              'Kho: ${color['quantity']}',
                                              style: TextStyle(
                                              fontWeight: FontWeight.bold),),
                                          ],
                                        ))));
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
                      Row(
                        children: [
                          const Text('Đánh Giá Sản Phẩm',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0)),
                          SizedBox(width: 10),
                          buildStarRating(averageRating),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0XFFD9D9D9),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: reviews.isEmpty
                                ? [
                                    Text('Không có đánh giá nào',
                                        style: TextStyle(fontSize: 15.0)),
                                  ]
                                : reviews
                                    .map((review) => Container(
                                          margin: EdgeInsets.only(bottom: 10.0),
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('${review['username']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14)),
                                              SizedBox(height: 4.0),
                                              Text('${review['comment']}',
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchReviewsByProductId(int productId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6/flutter/loadReviewbyProduct.php'),
        body: {
          'product_id': productId.toString(),
          'status': '1', // Chỉ lấy những đánh giá có status = 1
        },
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List) {
          setState(() {
            reviews = responseData;
            averageRating = calculateAverageRating(reviews);
          });
        } else {
          throw Exception('Invalid response format: Expected a List');
        }
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error, show message, etc.
    }
  }

  int calculateAverageRating(List<dynamic> reviews) {
    if (reviews.isEmpty) return 0;
    double sum = reviews.fold(0.0, (total, review) {
      int rating = int.parse(review['rating'].toString());
      return total + rating;
    });
    return (sum / reviews.length).round();
  }

  Widget buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }
}

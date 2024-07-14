import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReviewOrder extends StatefulWidget {
  final int pro_id;
  final int user_id;

  const ReviewOrder({Key? key, required this.pro_id, required this.user_id})
      : super(key: key);

  @override
  State<ReviewOrder> createState() => _ReviewOrderState();
}

class _ReviewOrderState extends State<ReviewOrder> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  int _rating = 0;
  int product_id = 0;

  Future<void> fetchProductID(int pro_id) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.5/flutter/loadproductid.php?pro_id=$pro_id'),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['product_id'] != null) {
          setState(() {
            product_id = int.parse(jsonResponse['product_id'].toString());
          });
        } else {
          throw Exception('product_id is null');
        }
      } else {
        throw Exception('Failed to load product_id');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductID(widget.pro_id);
  }

  Future<void> submitReview(int user_id) async {
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day}';
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.5/flutter/submitReview.php'),
        body: {
          'time': formattedDate,
          'user_id': user_id.toString(),
          'product_id': product_id.toString(),
          'review': _reviewController.text,
          'rating': _rating.toString(),
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gửi đánh giá thất bại. Vui lòng thử lại!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi trong quá trình gửi đánh giá.')),
      );
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đánh giá đơn hàng'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Đánh giá của bạn:', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập đánh giá của bạn tại đây',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập đánh giá của bạn';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('Đánh giá (từ 1 đến 5):', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                      ),
                      color: Colors.amber,
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                if (_rating == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Vui lòng chọn đánh giá',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _rating != 0) {
                        submitReview(widget.user_id);
                      } else if (_rating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Vui lòng chọn đánh giá')),
                        );
                      }
                    },
                    child: Text('Gửi đánh giá'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

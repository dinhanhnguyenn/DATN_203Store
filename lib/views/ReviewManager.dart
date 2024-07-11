import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewManager extends StatefulWidget {
  const ReviewManager({Key? key}) : super(key: key);

  @override
  State<ReviewManager> createState() => _ReviewManagerState();
}

class _ReviewManagerState extends State<ReviewManager> {
  List<dynamic> reviews = [];

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.5/flutter/loadreview.php'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          reviews = (json.decode(response.body) as List).map((data) {
            // Ép kiểu status về số nguyên
            return {
              ...data,
              'review_id': int.parse(data['review_id'].toString()),
              'status': int.parse(data['status']
                  .toString()), // Chuyển đổi status thành số nguyên
              'product_id': int.parse(data['product_id'].toString()),
              'user_id': int.parse(data['user_id'].toString()),
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateReviewStatus(int reviewId, int status) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.5/flutter/updateReviewStatus.php'),
        body: {
          'review_id': reviewId.toString(),
          'status': status.toString(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thành công!')),
        );
        fetchReviews(); // Refresh the list after update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật trạng thái thất bại.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Đã xảy ra lỗi trong quá trình cập nhật trạng thái.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đánh giá'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: reviews.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Đánh giá sản phẩm ${review['product_id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User ID: ${review['user_id']}'),
                        Text('Rating: ${review['rating']}'),
                        Text('Comment: ${review['comment']}'),
                        Text('Status: ${review['status']}'),
                      ],
                    ),
                    trailing: Switch(
                      value: review['status'] ==
                          1, // Chuyển đổi status thành số nguyên
                      onChanged: (value) {
                        int newStatus = value ? 1 : 0;
                        updateReviewStatus(review['review_id'], newStatus);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

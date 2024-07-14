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
        Uri.parse('http://192.168.1.6/flutter/loadreview.php'),
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedReviews =
            (json.decode(response.body) as List).map((data) {
          return {
            ...data,
            'review_id': int.parse(data['review_id'].toString()),
            'status': int.parse(data['status'].toString()),
            'product_id': int.parse(data['product_id'].toString()),
            'user_id': int.parse(data['user_id'].toString()),
          };
        }).toList();

        // Fetch product names and user emails for all reviews
        for (var review in fetchedReviews) {
          String productName = await fetchProductName(review['product_id']);
          String userEmail = await fetchUserEmail(review['user_id']);
          review['product_name'] = productName;
          review['user_email'] = userEmail;
        }

        setState(() {
          reviews = fetchedReviews;
        });
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> fetchProductName(int productId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.6/flutter/getProductName.php?product_id=$productId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['product_name'];
      } else {
        return 'Product not found';
      }
    } catch (e) {
      print('Error: $e');
      return 'Error fetching product name';
    }
  }

  Future<String> fetchUserEmail(int userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.6/flutter/getUserEmail.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['email'];
      } else {
        return 'User not found';
      }
    } catch (e) {
      print('Error: $e');
      return 'Error fetching user email';
    }
  }

  Future<void> updateReviewStatus(int reviewId, int status) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.6/flutter/updateReviewStatus.php'),
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
        backgroundColor: Colors.lightBlue[200],
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
                    title: Text(
                        'Đánh giá sản phẩm: ${review['product_name'].toString()}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID Người Dùng: ${review['user_id']}'),
                        Text('Email Người Dùng: ${review['user_email']}'),
                        Text('Đánh giá: ${review['rating']}'),
                        Text('Bình Luận: ${review['comment']}'),
                        Text('Trạng Thái: ${review['status']}'),
                      ],
                    ),
                    trailing: Switch(
                      value: review['status'] == 1,
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

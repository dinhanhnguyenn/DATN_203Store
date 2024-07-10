import 'dart:convert';

import 'package:http/http.dart' as http;

class UserInfo {
  final String fullName;
  final String phone;
  final String address;

  UserInfo(
      {required this.fullName, required this.phone, required this.address});
}

Future<UserInfo?> getUserInfo(int orderId) async {
  try {
    final response = await http.get(Uri.parse(
        'http://192.168.1.4/flutter/InformationUser.php?order_id=$orderId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success']) {
        return UserInfo(
          fullName: jsonData['user_info']['full_name'],
          phone: jsonData['user_info']['phone'],
          address: jsonData['user_info']['address'],
        );
      } else {
        print('Error: ${jsonData['message']}');
        return null;
      }
    } else {
      print(
          'Failed to retrieve user information. Error ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}

Future<int?> getTotalQuantity(int orderId) async {
  try {
    final response = await http.get(
        Uri.parse('http://192.168.1.4/flutter/quantity.php?order_id=$orderId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success']) {
        return jsonData['total_quantity'];
      } else {
        print('Error: ${jsonData['message']}');
        return null;
      }
    } else {
      print('Failed to retrieve total quantity. Error ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}

Future<double?> getTotalAmount(int orderId) async {
  try {
    final response = await http.get(Uri.parse(
        'http://192.168.1.4/flutter/TotalOrder.php?order_id=$orderId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success']) {
        return double.tryParse(jsonData['total'].toString());
      } else {
        print('Error: ${jsonData['message']}');
        return null;
      }
    } else {
      print('Failed to retrieve total amount. Error ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>?> getProducts(int orderId) async {
  try {
    final response = await http
        .get(Uri.parse('192.168.1.4/flutter/NamePrice.php?order_id=$orderId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success']) {
        List<Map<String, dynamic>> products = [];
        for (var product in jsonData['products']) {
          products.add({
            'name': product['name'],
            'price': double.tryParse(product['price'].toString()) ?? 0.0,
          });
        }
        return products;
      } else {
        print('Error: ${jsonData['message']}');
        return null;
      }
    } else {
      print('Failed to retrieve products. Error ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}

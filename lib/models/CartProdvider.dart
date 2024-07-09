import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  int _idCart = 0;

  int get idCart => _idCart;

  void setIdCart(int newIdCart) {
    print('Setting Cart ID: $newIdCart'); // In ra `cart_id` để kiểm tra
    _idCart = newIdCart;
    notifyListeners();
  }
}

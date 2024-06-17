import 'package:app_203store/widgets/GridProduct.dart';
import 'package:flutter/material.dart';

class ItemProducts extends StatefulWidget {
  const ItemProducts({super.key});

  @override
  State<ItemProducts> createState() => _ItemProductsState();
}

class _ItemProductsState extends State<ItemProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 60,
            color: Color(0xFFD9D9D9),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "iPhone Series",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: (){}, 
                    child: Row(
                      children: [
                        Text(
                          "Xem thêm",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                        Icon(
                          Icons.arrow_right_alt,
                          color: Colors.black,
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
          GridProducts()
        ],
      ),
    );
  }
}
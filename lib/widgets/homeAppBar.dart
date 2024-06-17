import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "203 Store",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.blue
              ),
            ),
            Text(
              "Cung cấp các sản phẩm Apple chính hãng",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13
              ),
            )
          ],
        ),
        Container(
          child: IconButton(
            onPressed: (){},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
              size: 35,
            )
          )
        )
      ],
    );
  }
}
import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  final String categories;
  final String image;

  const CategoriesWidget({
    super.key,
    required this.categories,
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Container(
        width: 110,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image),
            SizedBox(width: 2),
            Text(
              categories,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        )
      ),
    );
  }
}
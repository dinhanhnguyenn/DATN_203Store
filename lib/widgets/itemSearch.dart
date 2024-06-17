import 'package:app_203store/pages/searchPage.dart';
import 'package:flutter/material.dart';

class ItemSearch extends StatelessWidget {
  const ItemSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
              },
              icon: Icon(
                Icons.search,
                color:Colors.black
              )
            ),
            Container(
              width: 200,
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Nhập tên sản phẩm...",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
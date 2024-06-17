import 'package:app_203store/widgets/CSKH.dart';
import 'package:app_203store/widgets/GridProduct.dart';
import 'package:app_203store/widgets/bottomNavigator.dart';
import 'package:app_203store/widgets/categoriesWidget.dart';
import 'package:app_203store/widgets/homeAppBar.dart';
import 'package:app_203store/widgets/itemProducts.dart';
import 'package:app_203store/widgets/itemSearch.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const HomeAppBar(),
                  const SizedBox(height: 10),
                  const ItemSearch(),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF8e8e8e),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Center(
                      child: Text(
                        "Các sản phẩm của cửa hàng",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: 
              Container(
                child: ListView(
                  children: const [
                    GridProducts()
                  ],
                )
              )
            )
          ],
        )
      ),
      floatingActionButton: CSKH(),
    );
  }
}
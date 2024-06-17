import 'package:app_203store/widgets/CSKH.dart';
import 'package:app_203store/widgets/bottomNavigator.dart';
import 'package:app_203store/widgets/categoriesWidget.dart';
import 'package:app_203store/widgets/homeAppBar.dart';
import 'package:app_203store/widgets/itemProducts.dart';
import 'package:app_203store/widgets/itemSearch.dart';
import 'package:app_203store/widgets/slider.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigator(),
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
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CategoriesWidget(categories: "All", image: "assets/apple.png"),
                        CategoriesWidget(categories: "iPhone", image: "assets/iphone.png"),
                        CategoriesWidget(categories: "iPad", image: "assets/ipad.png"),
                        CategoriesWidget(categories: "Mac", image: "assets/mac.png"),
                        CategoriesWidget(categories: "Watch", image: "assets/watch.png"),
                        CategoriesWidget(categories: "Tai nghe", image: "assets/airpod.png"),
                        CategoriesWidget(categories: "Phụ kiện", image: "assets/type-c.png"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SliderHomePage()
                ],
              ),
            ),
            const SizedBox(height: 25),
            Expanded(child: 
              Container(
                child: ListView(
                  children: const [
                    ItemProducts(),
                    SizedBox(height: 10),
                    ItemProducts(),
                    SizedBox(height: 10),
                    ItemProducts(),
                    SizedBox(height: 10),
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
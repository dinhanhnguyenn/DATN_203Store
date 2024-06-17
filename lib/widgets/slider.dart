import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderHomePage extends StatefulWidget {
  @override
  State<SliderHomePage> createState() => _SliderHomePageState();
}

class _SliderHomePageState extends State<SliderHomePage> {
  final List<String> imagelist = [
    "assets/5.jpg",
    "assets/6.jpg",
    "assets/1.jpg",
    "assets/2.jpg",
    "assets/3.jpg",
    "assets/4.jpg",
    "assets/7.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          onPageChanged: (index, reason) {
            
          },
        ),
        items: imagelist.map((imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

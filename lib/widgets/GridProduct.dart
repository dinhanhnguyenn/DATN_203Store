import 'package:flutter/material.dart';

class GridProducts extends StatefulWidget {
  const GridProducts({super.key});

  @override
  State<GridProducts> createState() => _GridProductsState();
}

class _GridProductsState extends State<GridProducts> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20
        ),
        itemCount: 4,
        itemBuilder: (context, index){
          return InkWell(
            onTap: (){},
            borderRadius: BorderRadius.circular(20),
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xf1f0f0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/5.jpg",
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      "iPhone 15 Pro Max",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "35.000.000",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.red
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
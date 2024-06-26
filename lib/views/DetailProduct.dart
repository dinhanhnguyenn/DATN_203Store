import 'package:app_203store/views/Cart_Page.dart';
import 'package:app_203store/views/Payment_Page.dart';
import 'package:flutter/material.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {

  final List<String> color = [
    'Vàng',
    'Xanh lá',
    'Đen',
    'Xanh lam',
    'Hồng',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(
          Icons.phone_in_talk, 
          color: Colors.white
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MaterialButton(
              color: const Color(0xFF8E8E8E),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Cart()));
              },
              child: Container(
                alignment: Alignment.center,
                height: 70,
                child: const Center(
                  child: Text(
                    'Thêm vào giỏ hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                )
              ),
            ),
          ),
          Expanded(
            child: MaterialButton(
              color: Colors.red,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Payment()));
              },
              child: Container(
                alignment: Alignment.center,
                height: 70,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'MUA NGAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                      ),
                    ),
                    Text(
                      'Giao tận nơi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      "assets/5.jpg",
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8.0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "iPhone 15 PROMAX VN 512GB",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        "35.000.000 VND",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text('Màu sắc',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0
                        )
                      ),
                      InkWell(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 2.5,
                          ),
                          itemCount: color.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Card(
                                color: const Color(0xFFD9D9D9),
                                child: Center(
                                  child: 
                                  Text(
                                    color[index].toString()
                                  )
                                )
                              )
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Text('Chính sách bảo hành',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0
                        )
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0XFFD9D9D9),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Bảo hành 24 tháng")
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
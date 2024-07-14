import 'package:flutter/material.dart';

class CardPay extends StatelessWidget {
   CardPay({super.key,required this.image,required this.nameProduct,required this.quantity, required this.price, required this.colorName});
  var image;
  var nameProduct;
  var quantity;
  var price;
  var colorName;

  @override
  Widget build(BuildContext context) {
    return  Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          image != null
                              ? Image.network(
                                  'http://192.168.1.5/flutter/uploads/$image',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Container(),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              nameProduct != null
                                  ? Text(
                                      '$nameProduct',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Container(),
                              // Display color name if available
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              quantity != null
                                  ? Text(
                                      'Số lượng : $quantity',
                                      style: TextStyle(fontSize: 12),
                                    )
                                  : Container(),
                              price != null
                                  ? Text(
                                      'Giá : $price VNĐ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Container(),
                              colorName != null
                                  ? Text(
                                      'Màu : $colorName',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                    ),
                  );;
  }
}
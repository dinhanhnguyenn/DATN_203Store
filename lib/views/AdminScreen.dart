import 'dart:convert';

import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/AccountManagerScreen.dart';
import 'package:app_203store/views/AddProductDetail.dart';
import 'package:app_203store/views/AddProductScreen.dart';
import 'package:app_203store/views/CategoriesManagerScreen.dart';
import 'package:app_203store/views/DetailProduct.dart';
import 'package:app_203store/views/InfoProduct.dart';
import 'package:app_203store/views/OrderManager.dart';
import 'package:app_203store/views/ProductsManagerScreen.dart';
import 'package:app_203store/views/ReviewManager.dart';
import 'package:app_203store/views/Statistics_Page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  var formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

  @override
  void initState() {
    super.initState();
  }

  void _logout() {
    Provider.of<UserProvider>(context, listen: false).logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      loadProduct();
    });

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
              ),
              child: Text(
                'Manager',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.production_quantity_limits),
              title: Text(' Quản Lý Đơn Hàng'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageOrdersPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.border_outer_outlined),
              title: Text('Quản Lí Sản Phẩm'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductManagerScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Quản Lí Danh Mục'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoriesManagerScreen()),
                );
              },
            ),
            ListTile(
leading: Icon(Icons.person),
              title: Text('Quản Lí Tài Khoản'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountManagerScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.reviews),
              title: Text('Quản Lí Đánh Gía'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewManager()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.stacked_line_chart),
              title: Text('Thông Kê'),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatisticsPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Đăng xuất'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Đăng xuất'),
                      content: Text(
                          'Bạn có muốn đăng xuất không?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Hủy'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Đồng ý'),
                          onPressed: () {
                            _logout();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: Text(
          'ADMIN',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            FutureBuilder(
              future: loadProduct(),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<dynamic> productList = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: productList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  InfoProduct(product: productList[index]),
                              ),
                            );
                          },
                          child: Container(
                            width: 170,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 110,
                                    child: ClipRRect(
                                      child: Image.network(
                                        "http://192.168.1.6/flutter/uploads/${productList[index]["image"]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${productList[index]["name"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${formatCurrency.format(double.parse(productList[index]["price"]))}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List> loadProduct() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.6/flutter/loadProduct.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Load thất bại');
    }
  }
}
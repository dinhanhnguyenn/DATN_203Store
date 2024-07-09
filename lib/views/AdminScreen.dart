import 'dart:convert';

import 'package:app_203store/models/UserProvider.dart';
import 'package:app_203store/views/AccountManagerScreen.dart';
import 'package:app_203store/views/AddProductDetail.dart';
import 'package:app_203store/views/AddProductScreen.dart';
import 'package:app_203store/views/CategoriesManagerScreen.dart';
import 'package:app_203store/views/DetailProduct.dart';
import 'package:app_203store/views/OrderManager.dart';
import 'package:app_203store/views/ProductsManagerScreen.dart';
import 'package:app_203store/views/ReviewManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
              leading: Icon(Icons.reviews),
              title: Text('Thêm Sản Phẩm'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.reviews),
              title: Text('Thêm Chi Tiết Sản Phẩm'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddProductDetailScreen()),
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
              leading: Icon(Icons.history),
              title: Text('Thông Kê'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                _logout();
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
                                    DetailProduct(product: productList[index]),
                              ),
                            );
                          },
                          child: Card(
                            color: const Color(0xFFD9D9D9),
                            elevation: 7.0,
                            child: ListTile(
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Image.network(
                                        "http://192.168.30.35/flutter/uploads/${productList[index]["image"]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "${productList[index]["name"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Text(
                                      ' ${productList[index]["price"]} VND',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
        .get(Uri.parse('http://192.168.30.35/flutter/loadProduct.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Load thất bại');
    }
  }
}

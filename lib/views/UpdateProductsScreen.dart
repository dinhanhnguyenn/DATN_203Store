import 'dart:convert';
import 'dart:io';

import 'package:app_203store/models/Product.dart';
import 'package:app_203store/views/ProductsManagerScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UpdateProductScreen extends StatefulWidget {
  UpdateProductScreen({super.key, required this.product});
  var product;
  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {

  Product newproduct =
      Product(product_id: "", name: "", image: "", price: "", category_id: "", description: "",status: "");
  var tensp = TextEditingController();
  var dongiasp = TextEditingController();
  var mota = TextEditingController(); 

  String? loai;
  List<dynamic> categoryList = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
    tensp.text = '${widget.product["name"]}';
    dongiasp.text = '${widget.product["price"]}';
    mota.text = '${widget.product["description"]}';
    loai = '${widget.product["category_id"]}';
  }

  Future<void> loadCategories() async {
    final response = await http.get(Uri.parse('http://192.168.1.3/flutter/loadCategories.php'));
    if (response.statusCode == 200) {
      setState(() {
        categoryList = json.decode(response.body);
      });
    } else {
      throw Exception('Load thất bại');
    }
  }

  File? _image;
  final picker = ImagePicker();

  Future<void> choiceImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,true);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Cập nhật sản phẩm"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
             GestureDetector(
                onTap: () async {
                  await choiceImage();
                },
                child: Container(
                  width: 150,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
           
                  child: _image == null
                  ?  Image.network("http://192.168.1.3/flutter/uploads/${widget.product["image"]}", fit: BoxFit.cover, scale: 1.0,)
                  : Image.file(_image!, fit: BoxFit.cover),
                )
              ),
              const SizedBox(
                height: 12,
              ),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Tên sản phẩm ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: tensp,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  prefixIcon: const Icon(Icons.shopping_cart_rounded),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Giá Sản Phẩm ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: dongiasp,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  prefixIcon: const Icon(Icons.price_change),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Mô tả",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: mota,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  prefixIcon: const Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Loại",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 62.0,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10.0), // Set your desired border radius here
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: categoryList.isEmpty
                ? CircularProgressIndicator()
                : DropdownButtonFormField<String>(
                  value: loai,
                  onChanged: (String? newValue) {
                    setState(() {
                      loai = newValue;
                    });
                  },
                  items: categoryList.map<DropdownMenuItem<String>>((dynamic item) {
                    return DropdownMenuItem<String>(
                      value: item['category_id'].toString(),
                      child: Text(item['category_name']),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      print("Kết quả: " + loai!);
                      Product add = Product(
                        product_id: widget.product['product_id'],
                        name: tensp.text, 
                        image: _image?.path ?? "", 
                        price: dongiasp.text,
                        category_id: loai!,
                        description: mota.text,
                        status: 1.toString()
                      );
                       productUpdate(add);
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(180, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Colors.lightBlue[200]),
                    child: const Text(
                      "Cập nhật",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ));
  }
}

Future productUpdate(Product pro) async {
  final uri = Uri.parse('http://192.168.1.3/flutter/updateProduct.php');
  var request = http.MultipartRequest('POST', uri);
 
  request.fields['product_id'] = pro.product_id;
  request.fields['name'] = pro.name;
  request.fields['price'] = pro.price;
  request.fields['category_id'] = pro.category_id;
  request.fields['description'] = pro.description;
  request.fields['status'] = 1.toString();
  print(pro.image);

  if (pro.image.isNotEmpty) {
    var pic = await http.MultipartFile.fromPath("image", pro.image);
    request.files.add(pic);
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    print("Cập nhật thành công");
  } else {
    print("Cập nhật thất bại");
  }
}



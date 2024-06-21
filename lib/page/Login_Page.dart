import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[200],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  width: 450,
                  child: Image.asset("assets/login.jpg"),
                ),
                const Row(
                  children: [
                    Text(
                      "Xin Chào,",
                      style: TextStyle(fontSize: 30),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Đăng nhập tài khoản "),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Tạo Tài Khoản Mới",
                          style: TextStyle(color: Colors.lightBlue[200]),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      onChanged: (value) {},
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Email",
                      ),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                            onChanged: (value) {},
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: "Password",
                            ))),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          backgroundColor: Colors.lightBlue[200]),
                      onPressed: () {},
                      child: const Text(
                        "Đăng Nhập",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Bạn đã quên mật khẩu ?",
                          style: TextStyle(color: Colors.lightBlue[200]),
                        ))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

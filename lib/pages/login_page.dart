import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/pages/home_page.dart';
import '../models/ResponseModelLogin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  String _debug = "";

  Future<void> _login() async {
    final _body = {
      "email" : _email.text,
      "password" : _password.text,
    };
    try {
      final _response = await http.post(
        Uri.parse("http://localhost:8080/api_user_smart_home/login.php"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(_body),
      );
      if(_response.statusCode == 200){
        final responseModelLogin = responseModelLoginFromJson(_response.body);

        if(responseModelLogin.success){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>HomePage()));
          _debug = responseModelLogin.data!.email!;
        }else{
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content:
          Text(responseModelLogin.message)));
        }
      }
    } catch (e) {
      _debug = e.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content:
      Text(_debug)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 30),
                Text(
                  "Email",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: "rn.putra@gmail.com",
                    prefixIcon: Icon(Icons.email, color: Colors.red),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak Boleh kosong" : null;
                  },
                ),

                SizedBox(height: 20),
                Text(
                  "Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "******",
                    prefixIcon: Icon(Icons.key, color: Colors.red),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak Boleh kosong" : null;
                  },
                ),

                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    onPressed: () {
                      setState(() {
                        if(_formKey.currentState!.validate()){
                          _login();
                        }
                      });
                    },
                    child: Text("SAVE", style: TextStyle(color: Colors.white)),
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

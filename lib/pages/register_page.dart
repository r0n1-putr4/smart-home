import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/pages/login_page.dart';
import '../models/ResponseModelRegister.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _nama = TextEditingController();
  final _no_hp = TextEditingController();
  final _password = TextEditingController();
  final _alamat = TextEditingController();

  String _debug = "";

  Future<void> _register() async {
    final _body = {
      "email" : _email.text,
      "nama" : _nama.text,
      "no_hp" : _no_hp.text,
      "password" : _password.text,
      "alamat" : _alamat.text
    };
    try {
      final _response = await http.post(
        Uri.parse("http://localhost:8080/api_user_smart_home/insert.php"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(_body),
      );
      if(_response.statusCode == 200){
        final responseModelRegister = responseModelRegisterFromJson(_response.body);

        if(responseModelRegister.success){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>LoginPage()));
        }else{
         ScaffoldMessenger.of(context)
             .showSnackBar(SnackBar(content:
            Text(responseModelRegister.message)));
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
                    "Register",
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
                  "Nama",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                TextFormField(
                  controller: _nama,
                  decoration: InputDecoration(
                    hintText: "Roni Putra",
                    prefixIcon: Icon(Icons.person, color: Colors.red),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    return val!.isEmpty ? "Tidak Boleh kosong" : null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "No HP",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                TextFormField(
                  controller: _no_hp,
                  decoration: InputDecoration(
                    hintText: "082334563453",
                    prefixIcon: Icon(Icons.phone_android, color: Colors.red),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
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

                SizedBox(height: 20),
                Text(
                  "Alamat",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                TextFormField(
                  controller: _alamat,
                  decoration: InputDecoration(
                    hintText: "Jln. Parupuk Raya No. 84 Padang",
                    prefixIcon: Icon(Icons.map, color: Colors.red),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.streetAddress,
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
                          _register();
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

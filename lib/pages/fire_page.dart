import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirePage extends StatefulWidget {
  const FirePage({super.key});

  @override
  State<FirePage> createState() => _FirePageState();
}

class _FirePageState extends State<FirePage> {
  int _api_sensor = 1; //kondisi tidak terdeteksi api
  String _gambar = "assets/img/img_tidak_ada_api.png";
  late Timer _timer;

  Future<void> _getSensorApi() async {
    try {
      final _response = await http.get(
        Uri.parse(
          "http://10.20.29.11:8080/api/v1/12345/attributes?clientKeys=api_sensor",
        ),
      );

      if (_response.statusCode == 200) {
        final _dataResponse = jsonDecode(_response.body);
        setState(() {
          _api_sensor = _dataResponse['client']['api_sensor'];
          if (_api_sensor == 1) {
            //tidak terdeteksi api
            _gambar = "assets/img/img_tidak_ada_api.png";
          } else {
            //Terdeteksi api
            _gambar = "assets/img/img_detect_api.png";
          }
        });
      } else {
        //Tidak tersambung ke things board
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tidak tersambung ke thing board")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error : $e")));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSensorApi();
    _timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      _getSensorApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sensor API',style: TextStyle(color: Colors.white),),),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Expanded(child: Image.asset(_gambar)),
        ),
      ),
    );
  }
}

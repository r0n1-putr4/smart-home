import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LampuPage extends StatefulWidget {
  const LampuPage({super.key});

  @override
  State<LampuPage> createState() => _LampuPageState();
}

class _LampuPageState extends State<LampuPage> {
  int _lampu = 1;
  String _debug = "";
  Future<void> _getLampu() async{
    try{
      final _response = await http.get(
        Uri.parse(
          "http://103.252.189.62/api/v1/12345/attributes?clientKeys=lampu",
        ),
      );
      if (_response.statusCode == 200) {
        setState(() {
          final _dataResponse = jsonDecode(_response.body);
          _lampu = _dataResponse['client']['lampu'];
        });


      }
    }catch(e){
      setState(() {
        _debug = "Error $e";
      });

    }
  }
  Future<void> _sendLampu(int aktif) async {
    final _body = {"lampu": aktif};
    try {
      final _response = await http.post(
        Uri.parse("http://103.252.189.62/api/v1/12345/attributes"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(_body),
      );
      if(_response.statusCode == 200){
        setState(() {
          _lampu = aktif;
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _getLampu();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('$_lampu', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: RawMaterialButton(
            onPressed: () {
              setState(() {
                _sendLampu(_lampu == 0 ? 1 : 0);
              });

            },
            shape: CircleBorder(),
            elevation: 4,
            fillColor: _lampu == 0 ? Colors.yellow : Colors.grey,
            constraints: BoxConstraints.tightFor(width: 250, height: 250),
            child: Icon(Icons.lightbulb, size: 90),
          ),
        ),
      ),
    );
  }
}

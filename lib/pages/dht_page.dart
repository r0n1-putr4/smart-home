import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DhtPage extends StatefulWidget {
  const DhtPage({super.key});

  @override
  State<DhtPage> createState() => _DhtPageState();
}

class _DhtPageState extends State<DhtPage> {
  String _data = 'Loading..';
  double _suhu = 0.0;
  int? _kelembaban;
  late Timer _timer;

  //Mengambil data dari thinks board
  Future<void> _fecthDHT() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://103.252.189.62/api/v1/12345/attributes?clientKeys=suhu,kelembaban",
        ),
      );
      if (response.statusCode == 200) {
        final _dataResponse = jsonDecode(response.body);

        setState(() {
          _suhu = _dataResponse['client']["suhu"];
          _kelembaban = _dataResponse['client']["kelembaban"];
        });
      } else {
        setState(() {
          _data = 'Error ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _data = 'Error $e';
      });
    }
  }

  Color getSuhuWarna(double nilaiSuhu){
    if(nilaiSuhu<18) return Color(0xFF0000ff);
    else if(nilaiSuhu<23) return Color(0xFF00BFFF);
    else if(nilaiSuhu<28) return Color(0xFF00FF00);
    else if(nilaiSuhu<31) return Color(0xFFFFD700);
    else if(nilaiSuhu<36) return Color(0xFFFFA500);
    else return Color(0xFFFF0000);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fecthDHT();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      _fecthDHT();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Sensor DHT', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("SUHU", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
              SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: 18,
                        color: Color(0xFF0000ff),
                      ),
                      GaugeRange(
                        startValue: 18,
                        endValue: 22,
                        color: Color(0xFF00BFFF),
                      ),
                      GaugeRange(
                        startValue: 22,
                        endValue: 27,
                        color: Color(0xFF00FF00),
                      ),
                      GaugeRange(
                        startValue: 27,
                        endValue: 30,
                        color: Color(0xFFFFD700),
                      ),
                      GaugeRange(
                        startValue: 30,
                        endValue: 35,
                        color: Color(0xFFFFA500),
                      ),
                      GaugeRange(
                        startValue: 35,
                        endValue: 100,
                        color: Color(0xFFFF0000),
                      ),
                    ],
                    pointers: <GaugePointer>[NeedlePointer(value: _suhu,needleColor: getSuhuWarna(_suhu),)],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          '$_suhu',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
              Text("Kelembaban : $_kelembaban", style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

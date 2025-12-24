import 'package:flutter/material.dart';
import 'package:smart_home/pages/dht_page.dart';
import 'package:smart_home/pages/fire_page.dart';
import 'package:smart_home/pages/lampu_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Smart Home', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Roni Putra"),
              accountEmail: Text("rn.putra@gmail.com"),
              currentAccountPicture: CircleAvatar(
                radius: 55,
                child: Expanded(
                  child: Image(
                    image: NetworkImage(
                      "data:image/png;base64,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",
                    ),
                    width: 65,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Sensor DHT'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DhtPage()));
              },
            ),
            ListTile(
              title: Text('Sensor API'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FirePage()));
              },
            ),
            ListTile(
              title: Text('Kontrol Lampu'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LampuPage()));
              },
            )
          ],
        ),
      ),
      body: Center(child: Text('Home Page')),
    );
  }
}

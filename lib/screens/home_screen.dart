import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('RM 9.244.3', style: Theme.of(context).textTheme.headline),
            )
        ],
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.transparent
       ),
       child: DrawerSide(),
      ),
      body: Text('helow', style: TextStyle(color: Colors.red)),
    );
  }
}
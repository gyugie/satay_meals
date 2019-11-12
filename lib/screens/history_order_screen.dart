import 'package:flutter/material.dart';
import '../widgets/history_order_item.dart';

class HistoryOrdersScreen extends StatelessWidget {
  static const routeName = '/history-orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Oder', style: Theme.of(context).textTheme.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: 12,
          itemBuilder: (ctx, index) => HistoryItem(),
          
        ),
      )
    );
  }
}
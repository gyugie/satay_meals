import 'package:flutter/material.dart';
import 'package:satay_meals/widgets/order_item.dart';
import 'package:satay_meals/widgets/order_list.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
  final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order', style: Theme.of(context).textTheme.headline),
        actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('RM 9.244.3', style: Theme.of(context).textTheme.headline),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: deviceSize.height * 0.78 ,
              child: OrderList()
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: deviceSize.width * 0.9,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          label: Text('Checkout RM 122.0', style: Theme.of(context).textTheme.headline),
          
          onPressed: (){},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
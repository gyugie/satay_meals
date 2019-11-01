import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_list.dart';
import '../widgets/product_item.dart';
import '../widgets/drawer.dart';
import '../providers/auth.dart';
class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<Auth>(context, listen: false).role;
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
      backgroundColor: Theme.of(context).primaryColor,
      body: 
      /**
       * showing screen in accordance with the user role
       * consumer ProductList(),
       * courier OrderList(),
       * vendor OrderList(),
       */
      
      (userRole == 'consumer' ) ? ProductList() : (userRole == 'courier') ? null : ProductList()
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../providers/products.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final products  = Provider.of<Products>(context).products;

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, index) => OrderItem(
        products[index].id,
        products[index].name,
        products[index].price,
        products[index].priceOperator,
        products[index].imageUrl
      ),
    );
  }
}
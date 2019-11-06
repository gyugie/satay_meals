import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Products>(context, listen: false).products;
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(index),
        )
    );
  }
}
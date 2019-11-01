import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final int minOrder;
  final double price;
  final double priceOperator;
  final String imageUrl;

  Product({
    @required this.id,
    @required this.name,
              this.description,
    @required this.minOrder,
    @required this.price,
    @required this.priceOperator,
    @required this.imageUrl
  });
}

class Products with ChangeNotifier{
  List<Product> _products = [
        Product(
            id: '1',
            name: 'Chicken',
            description: "",
            minOrder: 1,
            price: 1.20,
            priceOperator: 1.00,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_28_29.jpg'
        ),
        Product(
            id: '2',
            name: 'Beef',
            description: "",
            minOrder: 1,
            price: 1.30,
            priceOperator: 1.10,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_29_03.jpg'
        ),
        Product(
            id: '3',
            name: 'Mutton',
            description: "",
            minOrder: 1,
            price: 1.40,
            priceOperator: 1.220,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_30_11.jpg'
        ),
        Product(
            id: '4',
            name: 'Nasi Implit',
            description: "",
            minOrder: 1,
            price: 1.50,
            priceOperator: 1.30,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_30_46.jpg'
        ),
        Product(
            id: '5',
            name: 'Perut',
            description: "",
            minOrder: 1,
            price: 1.60,
            priceOperator: 1.30,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_31_17.jpg'
        ),
    ];

    
  Products(this._products);


  List<Product> get products {
    return _products = [
        Product(
            id: '1',
            name: 'Chicken',
            description: "",
            minOrder: 1,
            price: 1.20,
            priceOperator: 1.00,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_28_29.jpg'
        ),
        Product(
            id: '2',
            name: 'Beef',
            description: "",
            minOrder: 1,
            price: 1.30,
            priceOperator: 1.10,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_29_03.jpg'
        ),
        Product(
            id: '3',
            name: 'Mutton',
            description: "",
            minOrder: 1,
            price: 1.40,
            priceOperator: 1.220,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_30_11.jpg'
        ),
        Product(
            id: '4',
            name: 'Nasi Implit',
            description: "",
            minOrder: 1,
            price: 1.50,
            priceOperator: 1.30,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_30_46.jpg'
        ),
        Product(
            id: '5',
            name: 'Perut',
            description: "",
            minOrder: 1,
            price: 1.60,
            priceOperator: 1.30,
            imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_31_17.jpg'
        ),
    ];
  }


}
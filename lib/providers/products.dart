import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../providers/http_exception.dart';

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
  final String _authToken;
  final String _userId;
  final String _role;

  List<Product> _products = [
        // Product(
        //     id: '1',
        //     name: 'Chicken',
        //     description: "",
        //     minOrder: 1,
        //     price: 1.20,
        //     priceOperator: 1.00,
        //     imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_28_29.jpg'
        // ),
        // Product(
        //     id: '2',
        //     name: 'Beef',
        //     description: "",
        //     minOrder: 1,
        //     price: 1.30,
        //     priceOperator: 1.10,
        //     imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_29_03.jpg'
        // ),
        // Product(
        //     id: '3',
        //     name: 'Mutton',
        //     description: "",
        //     minOrder: 1,
        //     price: 1.40,
        //     priceOperator: 1.220,
        //     imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_30_11.jpg'
        // ),
        // Product(
        //     id: '4',
        //     name: 'Nasi Implit',
        //     description: "",
        //     minOrder: 1,
        //     price: 1.50,
        //     priceOperator: 1.30,
        //     imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_30_46.jpg'
        // ),
        // Product(
        //     id: '5',
        //     name: 'Perut',
        //     description: "",
        //     minOrder: 1,
        //     price: 1.60,
        //     priceOperator: 1.30,
        //     imageUrl: 'https://adminbe.sw1975.com.my/assets/image/ImageProducts/2018_11_11_18_31_17.jpg'
        // ),
    ];

    
  Products(this._authToken, this._role, this._userId, this._products);

  var baseAPI       = 'https://adminbe.sw1975.com.my/index.php';
  final headersAPI  = {
                      'Content-Type': 'application/json'
                    };

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchFoods() async {
    try{
        headersAPI['token'] = _authToken;
        final List<Product> loadedProducts = [];

        final response = await http.post(
          baseAPI + '/API_Consumer/getFoods',
          headers: headersAPI,
          body: json.encode({
            'type': 'consumer'
          }));


       final responseData = json.decode(response.body);
        if(responseData['success'] == false){
          throw HttpException(responseData['message']);
        }
       
        for(int i = 0; i < responseData['data'].length; i++){
          loadedProducts.add(Product(
            id: responseData['data'][i]['id'],
            name: responseData['data'][i]['name'],
            price: double.parse(responseData['data'][i]['price']),
            priceOperator: double.parse(responseData['data'][i]['price_operator']),
            minOrder: int.parse(responseData['data'][i]['min_order']),
            description: responseData['data'][i]['description'],
            imageUrl: responseData['data'][i]['image']
          ));    
          _products = loadedProducts;
          notifyListeners();
        }

    } catch (err){
      throw err;
    }
  }


}
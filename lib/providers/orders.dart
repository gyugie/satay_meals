import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import './cart_item.dart';

class Order{
  final String consumerId;
  final String address;
  final String latitude;
  final String longitude;
  final int phone;
  final int post_code;
  final int city;
  final int state;
  final double total;
  final List<Item> item;

  Order({
   @required this.consumerId, 
   @required this.address,
   @required this.latitude, 
   @required this.longitude, 
   @required this.phone, 
    this.post_code, 
    this.city, 
    this.state, 
  @required this.total, 
  @required this.item
    });

}

class ItemOrders with ChangeNotifier {
final String _authToken;

ItemOrders(this._authToken);

var baseAPI       = 'https://adminbe.sw1975.com.my/index.php';
final headersAPI  = {
                    "Accept": "application/json",
                    "Content-Type": "application/x-www-form-urlencoded"
                  };

Future<void> addOrder(String consumerId, String address, String latitude, String longitude, int phone, double total, List<Item> items ) async {

  try{
    headersAPI['token'] = _authToken;
    final response = await http.post( 
      baseAPI + '/API_Consumer/orderFoods',
      headers: headersAPI,
      body: {
        'consumer_id': consumerId,
        'total': total.toString(),
        'address': address,
        'lat': latitude,
        'lng': longitude,
        'phone': phone.toString(),
        'post_code': '',
        'city': '',
        'state': '',
        'item': json.encode(
            items.map( (cart) =>{
            'product_id': cart.productId,
            'price': cart.price,
            'quantity': cart.quantity
          }).toList()
        )
      }
    );
   


    final responseData = json.decode(response.body);
    print(responseData);
  } catch (err){
    throw err;
  }
}



}



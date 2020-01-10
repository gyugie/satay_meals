import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import './http_exception.dart';
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

class HistoryOrder with ChangeNotifier {
  final String noTransaction;
  final String orderId;
  final String statusOrder;
  final String total;
  final String createdAt;
  final String vendor;
  final String rider;
  final String tableName;

  HistoryOrder({
    @required this.noTransaction,
    @required this.orderId,
    @required this.statusOrder,
    @required this.createdAt,
    @required this.total,
    @required this.tableName,
    this.vendor,
    this.rider,
  });
}



class ItemOrders with ChangeNotifier {
final String _authToken;
final String _role;
final String _userId;
List<HistoryOrder> _historyOrders = [];

ItemOrders(this._authToken, this._role, this._userId);

var baseAPI       = 'https://adminbe.sw1975.com.my/index.php';
final headersAPI  = {
                    "Accept": "application/json",
                    "Content-Type": "application/x-www-form-urlencoded"
                  };


List<HistoryOrder> get history {
  return [..._historyOrders];
}

Future<void> addOrder(String consumerId, String address, String latitude, String longitude, String phone, String total, List<Item> items ) async {

  try{
    headersAPI['token'] = _authToken;
    final response = await http.post( 
      baseAPI + '/API_Consumer/orderFoods',
      headers: headersAPI,
      body: {
        'consumer_id': consumerId,
        'total': total,
        'address': address,
        'lat': latitude,
        'lng': longitude,
        'phone': phone,
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
    if(responseData['success'] == false){
      throw HttpException(responseData['message']);
    }print(responseData);

  } catch (err){
    throw err;
  }
}

Future<void> getHistoryOrders() async {
  try{
    headersAPI['token'] = _authToken;
    final List<HistoryOrder> loadedHistoryOrders  = [];

    final response = await http.post(
      baseAPI + '/API_Consumer/getHistoryOrder',
      headers: headersAPI,
      body: {
        'id' : _userId
      }
    );

    final responseData  = json.decode(response.body);
    if(responseData['success'] == false){
      throw HttpException(responseData['message']);
    }
    _historyOrders = [];
    for(int i = 0; i < responseData['data'].length; i++){
      loadedHistoryOrders.add(HistoryOrder(
        noTransaction: responseData['data'][i]['no_transaction'],
        orderId: responseData['data'][i]['id'],
        statusOrder: responseData['data'][i]['status'],
        total: responseData['data'][i]['total'],
        createdAt: responseData['data'][i]['createdAt'],
        rider: responseData['data'][i]['rider'],
        vendor: responseData['data'][i]['vendor'],
        tableName: responseData['data'][i]['name_table']
      ));
      _historyOrders = loadedHistoryOrders;
      notifyListeners();
    }


  } catch (err){
    throw err;
  }

}

Future<void> getDetailOrder(String id, String tableName) async {
  var results;

  try{
    
    headersAPI['token'] = _authToken;
    final response = await http.post(
      baseAPI + '/API_Account/OrderDetail',
      headers: headersAPI,
      body: {
        'id' : id,
        'type': _role,
        'table_name': tableName
      }
    );

    final responseData = json.decode(response.body);
   if(responseData['success'] == false){
      throw HttpException(responseData['message']);
    } 

    results = response.body;
  
  } catch (err){
    throw err;
  }

  return results;
}

Future<void> confirmOrder(String orderID) async {
  try{

    headersAPI['token'] = _authToken;
    final response = await http.post(
      baseAPI + '/API_Consumer/approvOrder',
      headers: headersAPI,
      body: {
        'order_id' : orderID
      }
    );

    final responseData  = json.decode(response.body);
    if(responseData['success'] == false){
      throw HttpException(responseData['message']);
    }
  }catch (err){
    throw err;
  }

}

Future<void> cancelOrder(String orderID) async {
  try{

    headersAPI['token'] = _authToken;
    final response = await http.post(
      baseAPI + '/API_Consumer/rejectOrder',
      headers: headersAPI,
      body: {
        'order_id' : orderID
      }
    );

    final responseData  = json.decode(response.body);
    if(responseData['success'] == false){
      throw HttpException(responseData['message']);
    }
  }catch (err){
    throw err;
  }
}
}



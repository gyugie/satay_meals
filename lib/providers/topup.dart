import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../providers/http_exception.dart';

class Topup {
  final String id;
  final String package;
  final double price;
  final double amount;

  Topup({this.id, this.package, this.price, this.amount});

}

class SatayTopup with ChangeNotifier {
  final String _userId;
  final String _authToken;
  final String _userRole;
  List<Topup> _listPackage = [];
  List<Topup> _listPendingPackage = [];

  SatayTopup(this._userId, this._authToken, this._userRole);
  var baseAPI       = 'https://adminbe.sw1975.com.my/index.php';
  final headersAPI  = {
                    "Accept": "application/json",
                    "Content-Type": "application/x-www-form-urlencoded"
                  };

  List<Topup> get packagePurchase {
    return [..._listPackage];
  }

  List<Topup> get pendingPurchasePackage {
    return [..._listPendingPackage];
  }

  Future<void> fetchListTopup() async {
    try{
      headersAPI['token'] = _authToken;
      final response = await http.post(
        baseAPI + '/API_TopUp/ListTopUp',
        headers: headersAPI,
        body: {
          'type': _userRole
        }
      );

      final responseData = json.decode(response.body);
      if(responseData['success'] == false){
        throw HttpException(responseData['message']);
      }

      for(int i = 0; i < responseData['data'].length; i++){
        _listPackage.add(Topup(
          id: responseData['data'][i]['id'],
          package: responseData['data'][i]['ammount'],
          amount: double.parse(responseData['data'][i]['value']),
          price: double.parse(responseData['data'][i]['price'])
        ));
        notifyListeners();
      }

    } catch (err){
      throw err;
    }
  }

  Future<void> fetchPendingTopup() async {

    try{
      headersAPI['token'] = _authToken;
      final response = await http.post(
        baseAPI + '/API_TopUp/ListPendingTopUp',
        headers: headersAPI,
        body: {
          'type'  : _userRole,
          'id'    : _userId
        }
      );

      final responseData = json.decode(response.body);
      if(responseData['success'] == false){
        throw HttpException(responseData['message']);
      }
      
      _listPendingPackage = [];
      if(responseData['data'].length > 0){
        for(int i = 0; i < responseData['data'].length; i++){
          _listPendingPackage.add(Topup(
            id: responseData['data'][i]['id'],
            package: responseData['data'][i]['list_amount'],
            amount: double.parse(responseData['data'][i]['list_value']),
            price: double.parse(responseData['data'][i]['list_price'])
          ));
          notifyListeners();
        }
      }

    } catch (err){
      throw err;
    }
  }
} 
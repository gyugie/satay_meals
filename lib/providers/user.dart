import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:satay_meals/providers/http_exception.dart';

class User with ChangeNotifier {
  final String _authToken;
  final String _userId;
  final String _userRole;
  double _myWallet = 0.0;

  User(this._authToken, this._userId, this._userRole);
  var baseAPI       = 'https://adminbe.sw1975.com.my/index.php';
  final headersAPI  = {
                      "Accept": "application/json",
                      "Content-Type": "application/x-www-form-urlencoded"
                    };

  Location location = Location();
  Map<String, double> userLocation;

  Future<Map<String, double>> getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  double get myWallet {
    return _myWallet;
  }  

  Future<void> getMyWallet() async {
   
    try{
      headersAPI['token'] = _authToken;
      final response = await http.post(
        baseAPI + '/API_Account/myWallet',
        headers: headersAPI,
        body: {
          'id'    : _userId,
          'type'  : _userRole 
        });

        final responseData = json.decode(response.body);
        if(responseData['success'] == false){
          throw HttpException(responseData['message']);
        }

        _myWallet = double.parse(responseData['data']['wallet_balance']);
        notifyListeners();
    }catch (err){
      throw err;
    }
   
  }

  Future<void> getTermsAndCondition() async {
    var result;
    try{
      headersAPI['token'] = _authToken;
      final response = await http.post(
        baseAPI + '/API_Account/GetPrivacy',
        headers: headersAPI,
        body: {
          'type': _userRole
        }
      );

       final responseData = json.decode(response.body);
        if(responseData['success'] == false){
          throw HttpException(responseData['message']);
        }

      result = response.body;

    } catch (err){
      throw err;
    }

    return result;
  }
}
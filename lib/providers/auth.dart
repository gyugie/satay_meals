import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './http_exception.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiredToken;
  String _userId;
  Timer _timer;

  var baseAPI       = 'https://adminbe.sw1975.com.my/index.php';
  final headersAPI  = {
                      "Accept": "application/json",
                      "Content-Type": "application/x-www-form-urlencoded"
                    };
  bool get isAuth {
    return token != null;
  }

  String get token {
    if(_token != null && _userId != null && _expiredToken.isAfter(DateTime.now())){
      return _token;
    }

    return null;
  }

  Future<void> signUp(String username, String email, String password, int phone) async {
    try{
      final response = await http.post(
          baseAPI + '/API_Consumer/register', 
          headers: headersAPI,
          body: {
            'username': username,
            'password': password,
            'email'   : email,
            'phone'   : phone.toString()
          },
        );

      final responseData = json.decode(response.body);
      
      if(responseData['success'] == false){
        throw HttpException(responseData['message']);
      }

    } catch (err){
      throw err;
    }
  }

  Future<void> login() async {

  final response = await http.post(
          baseAPI + '/API_Consumer/register', 
          headers: headersAPI,
          body: {
            'username': 'gyugie',
            'password': 'password',
            'email'   : 'mugypleci@gmail.com',
            'phone'   : '089666528074'
          },
        );
      print(json.decode(response.body));
  }


}
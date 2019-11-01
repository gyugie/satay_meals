import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './http_exception.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiredToken;
  String _userId;
  String _role;
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
    if(_token != null && _userId != null && _expiredToken != null ){
      return _token;
    }

    return null;
  }

  String get role {
    if(_token != null && _userId != null && _expiredToken != null ){
      return _role;
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

  Future<void> login(String username, String password) async {

      try{
        final response = await http.post(
          baseAPI + '/API_Account/login', 
          headers: headersAPI,
          body: {
            'username': username,
            'password': password,
          },
        );

      final responseData = json.decode(response.body);
      

      if(responseData['verified'] == false ){
        throw HttpException('Account is not active, please check on youre email for verified account');
      } else if(responseData['success'] == false) {
         throw HttpException(responseData['message']);
      }

      //set session on local storage
      _token  = responseData['data']['token'];
      _userId = responseData['data']['id'];
      _role   = responseData['data']['type']; 
      _expiredToken = DateTime.now().add(Duration(seconds: 43200)); // 1/2 day

      notifyListeners();
      _autoLogout();
      final prefs     = await SharedPreferences.getInstance();
      final userData  = json.encode({
        'token' : _token,
        'userId': _userId,
        'role': _role,
        'expiredToken' : _expiredToken.toIso8601String()
      });

      prefs.setString('userData', userData);

      } catch (err){
        throw err;
      }

  }

  Future<void> tryToAutoLogin() async {
    final prefs         = await SharedPreferences.getInstance();
    final extractData   = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiredDate   = DateTime.parse(extractData['expiredToken']);

    if(expiredDate.isBefore(DateTime.now())){
      return false;
    }

    _token        = extractData['token'];
    _userId       = extractData['userId'];
    _role         = extractData['role'];
    _expiredToken = expiredDate;

    notifyListeners(); 
    return true;
  }

  Future<void> logout() async {
    _token        = null;
    _userId       = null;
    _expiredToken = null;
    if(_timer != null){
      _timer.cancel();
      _timer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

  }

  Future<void> _autoLogout(){
   if(_timer != null){
     _timer.cancel();
   }

   final timeExpired = _expiredToken.difference(DateTime.now()).inSeconds;
   _timer = Timer(Duration(seconds: timeExpired), logout);
 }

}
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './http_exception.dart';
import 'package:location/location.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Auth with ChangeNotifier{
  final FirebaseMessaging _firebaseMessaging  = FirebaseMessaging();  
  String _token;
  DateTime _expiredToken;
  String _userId;
  String _role;
  Timer _timer;
  String _firebaseToken;
  Map<String, double> currentLocation = {};
  Location location = new Location();
  final GoogleSignIn googleSignIn         = GoogleSignIn();
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

  String get userId {
    if(_token != null && _userId != null && _expiredToken != null ){
      return _userId;
    }

    return null;
  }

  
  Future<Map<String, double>> getLocation() async {
   
       await location.getLocation().then( (res) async {
         currentLocation['latitude']  = res.latitude;
         currentLocation['longitude'] = res.longitude;

       }).catchError( (err){
         currentLocation['latitude']  = null;
         currentLocation['longitude'] = null;
         throw err;
       });

      

    return currentLocation;
  }



  Future<void> firebaseToken() async {
    await _firebaseMessaging.getToken().then( (results){
      _firebaseToken = results;
    }).catchError( (err){
      throw err;
    });
  }

  Future<void> signUp(String username, String email, String password, String phone, String googleUid ) async {
  
    try{
      final response = await http.post(
          baseAPI + '/API_Consumer/register', 
          headers: headersAPI,
          body: {
            'username': username,
            'password': password,
            'email'   : email,
            'phone'   : phone,
            'google'  : googleUid
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

  Future<void> login(String username, String password, String googleUid, bool isGoogle) async {
    print(googleUid);
      try{
        var response;
        
        if(isGoogle){
          response = await http.post(
            baseAPI + '/API_Account/loginGoogle', 
            headers: headersAPI,
            body: {
              'uid': googleUid,
              'token_firebase': _firebaseToken
            },
          );
        } else {
          response = await http.post(
            baseAPI + '/API_Account/login', 
            headers: headersAPI,
            body: {
              'username': username,
              'password': password,
              'token_firebase': _firebaseToken
            },
          );
        }
         

      final responseData = json.decode(response.body);
      print(responseData);
      if(responseData['verified'] == false ){
        _userId = responseData['data']['id'];
        _role   = responseData['data']['type']; 
       
        throw HttpException('Account is not active, please check on your email for verifying account');
      } else if(responseData['success'] == false) {
         throw HttpException(responseData['message']);
      }

      if(responseData['success'] == true){
         if(responseData['data']['type'] != 'consumer' ){
          throw HttpException('Your account don`t have login with this app');
         }
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

  Future<void> verificationCode(String codeActivation) async {
    try{
      final response = await http.post(
        baseAPI + '/API_Account/verified',
        body: {
          'id': _userId,
          'type': _role,
          'verified': codeActivation
        }
      );

    final responseData = json.decode(response.body);
     
     if(responseData['success'] == false){
       throw HttpException(responseData['message']);
     }

    } catch (err){
      throw err;
    }
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
    
    signOutGoogle();

  }

  _autoLogout(){
    if(_timer != null){
      _timer.cancel();
    }

    final timeExpired = _expiredToken.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: timeExpired), logout);
  }

  void signOutGoogle() async{
    await googleSignIn.disconnect();
}

  Future<void> changePassword(String oldPassword, String newPassword) async {

    try{
        headersAPI['token'] = _token;
        final response = await http.post(
          baseAPI + '/API_Account/changePassword',
          headers: headersAPI,
          body: {
            'id'            : _userId,
            'type'          : _role,
            'old_password'  : oldPassword,
            'new_password'  : newPassword
          }
        );
        final responseData = json.decode(response.body);
        if(responseData['success'] == false){
            throw HttpException(responseData['message']);
          }
    } catch (err){
      throw err;
    }

  }  








  

}
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:satay_meals/providers/http_exception.dart';

class UserTemp {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final int facebookId;
  final int googleId;
  final String joinDate;
  final String image;
  final String latitude;
  final String longitude;
  final String postalCode;
  final int stateId;
  final String stateName;
  final int cityId;
  final String cityName;

  UserTemp({
    @required this.id,
    @required this.username,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.phone,
    @required this.address,
    @required this.facebookId,
    @required this.googleId,
    @required this.joinDate,
    @required this.image,
    @required this.latitude,
    @required this.longitude,
    @required this.postalCode,
    @required this.stateId,
    @required this.stateName,
    @required this.cityId,
    @required this.cityName,
  });
}

class UserState {
  final int stateId;
  final String stateName;

  UserState({this.stateId, this.stateName});
}

class UserCity {
  final int cityId;
  final String cityName;

  UserCity({this.cityId, this.cityName});
}


class User with ChangeNotifier {
  final String _authToken;
  final String _userId;
  final String _userRole;
  double _myWallet = 0.0;
  Map<String, UserTemp> _userProfile = {};
  Dio dio = new Dio();

  User(this._authToken, this._userId, this._userRole);
  var baseAPI       = 'https://adminbe.sw1975.com.my/index.php';
  final headersAPI  = {
                      "Accept": "application/json",
                      "Content-Type": "application/x-www-form-urlencoded"
                    };

  Map<String, double> currentLocation = {};
  Location location = new Location();

  Map<String, UserTemp> get userProfile{
    return {..._userProfile};
  }

  Future<void> fetchUserProfile() async {
    try{
      headersAPI['token'] = _authToken;
      final response = await http.post(
        baseAPI + '/API_Account/myProfile',
        headers: headersAPI,
        body: {
          'id': _userId,
          'type': _userRole
        }
      );

      final responseData = json.decode(response.body);
      if(responseData['success'] == false){
        throw HttpException(responseData['message']);
      }
      _userProfile = {};
      _userProfile.putIfAbsent('userProfile', () => UserTemp(
        id          : responseData['data']['id'],
        username    : responseData['data']['username'], 
        firstName   : responseData['data']['first_name'],
        lastName    : responseData['data']['last_name'],
        email       : responseData['data']['email'],
        phone       : responseData['data']['phone'] != null ? responseData['data']['phone'] : null,
        address     : responseData['data']['address'],
        facebookId  : responseData['data']['id_facebook'] != null ? int.parse(responseData['data']['id_facebook']) : null,
        googleId    : responseData['data']['id_google'] != null ? int.parse(responseData['data']['id_google']) : null,
        joinDate    : responseData['data']['join_date'],
        image       : responseData['data']['image'],
        latitude    : responseData['data']['lat'],
        longitude   : responseData['data']['lng'],
        postalCode  : responseData['data']['post_code'],
        stateId     : responseData['data']['state_id'] != null ? int.parse(responseData['data']['state_id']) : null,
        stateName   : responseData['data']['state_name'],
        cityId      : responseData['data']['city_id'] != '' ? int.parse(responseData['data']['city_id']) : null,
        cityName    : responseData['data']['city_name'],
      ));
      notifyListeners();
    }catch (err){
      throw err;
    }

  }

  Future<void> updateUserProfile(String fileName, String path, String username,String firstName, String lastName, String address, String latitude, String longitude, String postalCode, String cityId, String stateId, String phone) async {
    try{
      print(phone);
        dio.options.headers= {"token" : _authToken};
        FormData formData = new FormData.from({
                'id'          : _userId,
                'type'        : _userRole,
                'nickname'    : username,
                'username'    : username,
                'phone'       : phone,
                'first_name'  : firstName,
                'last_name'   : lastName,
                'address'     : address,
                'lat'         : latitude,
                'lng'         : longitude,
                'post_code'   : postalCode,
                'city_id'     : cityId,
                'state_id'    : stateId,
                "file"        : fileName != null ? new UploadFileInfo(new File(path), fileName) : ''
            });
      var response = await dio.post(
                      baseAPI + "/API_Account/editProfile",
                      data: formData
                    );
      if(response.data['success'] == false){
        throw HttpException(response.data['message']);
      }

    }catch (err){
      throw err;
    }

  }

  Future<Map<String, double>> getLocation() async {
      
       await location.getLocation().then( (res){
         currentLocation['latitude'] = res.latitude;
         currentLocation['longitude'] = res.longitude;
       }).catchError( (err){
         currentLocation['latitude']  = null;
         currentLocation['longitude'] = null;
         throw err;
       });
       
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

  Future<void> getAboutUs() async {
    var result;
    try{
      headersAPI['token'] = _authToken;
      final response = await http.post(
        baseAPI + '/API_Account/GetAboutUs',
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

  Future<void> fetchListState() async {
   var result;
    try{
      headersAPI['token'] = _authToken;
      final response = await http.post(
        baseAPI + '/API_Account/GetAllState',
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

  Future<void> fetchListCity(String stateId ) async {
    var result;
    try{
      headersAPI['token'] = _authToken;
      final response = await http.post(
        baseAPI + '/API_Account/GetAllCitybyState',
        headers: headersAPI,
        body: {
          'type': _userRole,
          'id'  : stateId
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

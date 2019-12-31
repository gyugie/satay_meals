import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import './http_exception.dart';
import './auth.dart';

class MapsAddress {
  final String description;
  final String address;

  MapsAddress({this.description, this.address});
}

class MapsAutocomplete extends ChangeNotifier {
  final String _authToken;
  final String _role;
  final String _userId;
  List<MapsAddress> _recomendAddress = [];

  MapsAutocomplete(this._authToken, this._role, this._userId, this._recomendAddress);

  final headersAPI      = {
                          "Accept": "application/json",
                          "Content-Type": "application/x-www-form-urlencoded"
                        };
                  
  List<MapsAddress> get recomendAddress {
    return [..._recomendAddress];
  }
  
  Future<void> findAddress(BuildContext context, String queryString, String tokenGoogleMaps) async {
    try{
      final coordinate  = await Provider.of<Auth>(context).getLocation();
      final response    = await http.get(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?location=$coordinate['latitude'],$coordinate['longitude']&key=$tokenGoogleMaps&input=$queryString&componentRestrictions=id",
        headers: headersAPI,
      );

      final responseData = json.decode(response.body);
      // if(responseData['status'] == "ZERO_RESULTS"){
      //   throw HttpException('Address Not Found!');
      // }

      _recomendAddress = [];
      for(int i = 0; i < responseData['predictions'].length; i++){
        _recomendAddress.add(MapsAddress(
              description : responseData['predictions'][i]['description'], 
              address     : responseData['predictions'][i]['structured_formatting']['secondary_text']
            ));

          notifyListeners();
      }
      print('object');
    } catch (err){
      throw err;
    }
  }

}
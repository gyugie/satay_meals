import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class User with ChangeNotifier {
  
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
}
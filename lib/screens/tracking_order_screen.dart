import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:quiver/async.dart';

import '../widgets/custom_notification.dart';
import '../utils/Uint8List.dart';

const kGoogleApiKey = "AIzaSyB-ed7fvN577q8h7s7srJVqoTKO_srddAo";
const String URI = 'https://adminbe.sw1975.com.my:3000/';

class TrackingOrderScreen extends StatefulWidget {
   String orderID;

  TrackingOrderScreen({this.orderID});
  
  @override
  _TrackingOrderScreenState createState() => _TrackingOrderScreenState();
}

class _TrackingOrderScreenState extends State<TrackingOrderScreen> {
  var _isInit     = true;
  var _isLoading  = true;
  List _riderPositionTemp = [];
  int _counter    = 0;
  int _start = 10;
  int _current = 10;


  @override  
  void initState() {  
    super.initState();  
  
    //Init local notification
    initSocket(widget.orderID);
    initCustomIcon();
  }
  /**************************************************
   *                SOCKET INIT        
   *************************************************/
  IO.Socket socket = IO.io(URI, <String, dynamic>{
    'transports': ['websocket'],
    'extraHeaders': {'foo':'bar'} // optional,
    
  });

  void initSocket(String orderID)  {
    socket.on('connect', (_) {
      socket.on('get_loc_'+ orderID, (response) async {
            if(_riderPositionTemp.length < 5 ){
               setState(() {
                _isLoading = false;
              });
            }
            
            // buffer data to variable 
            _riderPositionTemp.add({
              'latitude'  : response['data']['latitude'],
              'longitude' : response['data']['longitude'],
              'room'      : response['data']['room']
            });

            if(widget.orderID != '0'){
              setState(() {
                latitudeFromString = _riderPositionTemp[_riderPositionTemp.length - 1 ]['latitude'];
                longitudeFromString= _riderPositionTemp[_riderPositionTemp.length - 1 ]['longitude'];
              });
            //  print(latitudeFromString + longitudeFromString);
            }

        });

    });
                 
      socket.on('event', (data) => print('disconnect'));
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
      socket.connect();
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() { 
        _current = _start - duration.elapsed.inSeconds; 
        });
    });

    sub.onDone(() {
      if(_riderPositionTemp.length == 0){
       CustomNotif.alertDialogWithIcon(context, Icons.warning, 'Tracking Not Available Now', 'rider is offline, please try again later', true, true);
      }
      sub.cancel();
    });
  }


  /**************************************************
   *                GOOGLE MAPS INIT        
   *************************************************/
  static final LatLng center      = const LatLng( -6.914744, 107.609810);
  Map<MarkerId, Marker> markers   = <MarkerId, Marker>{};
  int _markerIdCounter            = 1;
  double latitudeFromString       = null;
  double longitudeFromString      = null;
  GoogleMapController controller;
  MarkerId selectedMarker;
  Uint8List markerIcon;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(center.latitude, center.longitude),
    zoom: 10,
  );

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  void initCustomIcon() async {
     var icon  = await getBytesFromAsset('assets/images/driver.png', 100);
        setState(() {
          markerIcon = icon;
        });
  }
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_isInit){
      socket.emit('room', widget.orderID);
      startTimer();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize        = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            setState(() {
              widget.orderID = '0';
            });
            initSocket('-0');
            Navigator.of(context).pop();
            print('closes ${widget.orderID}');
          },
        ),
        iconTheme: new IconThemeData(color: Colors.green),
        title: Text('Tracking Your Order', style: Theme.of(context).textTheme.title),
      ),
      body: 
      _isLoading 
      ?
      Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
      :
      Container(
        height: deviceSize.height,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // https://github.com/flutter/flutter/issues/28312
          // ignore: prefer_collection_literals
          // markers: Set<Marker>.of(markers.values),
          markers: Set<Marker>.of(
            <Marker>[
              Marker(
                draggable: false,
                markerId: MarkerId("1"),
                position: LatLng(latitudeFromString, longitudeFromString ),
                icon: BitmapDescriptor.fromBytes(markerIcon),
              )
            ],
          ),
          
        ),
      ),
    );
  }
}

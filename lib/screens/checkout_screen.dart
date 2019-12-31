import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';


import '../screens/history_order_screen.dart';
import '../providers/auth.dart';
import '../screens/home_screen.dart';
import '../providers/cart_item.dart';
import '../providers/user.dart';
import '../providers/orders.dart';
import '../providers/maps.dart';

const kGoogleApiKey = "AIzaSyB-ed7fvN577q8h7s7srJVqoTKO_srddAo";


class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout-screen';
  
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}
final homeScaffoldKey = new GlobalKey<ScaffoldState>();
final searchScaffoldKey = new GlobalKey<ScaffoldState>();

class _CheckoutScreenState extends State<CheckoutScreen> 
  with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>(debugLabel: '/checkout-screen' );
  TextEditingController _searchQuery;
  bool _isSearching                                 = false;
  String searchQuery                                = "Search query";
  double _setHeigtItemList                          = 0.1;
  var _clickCount                                   = 0;              
  var _isLoading                                    = false;
  var _isInit                                       = true;
  static Map<String, double> userLocation;
  var _disabledButton                               = false;
  TextEditingController _phoneController            = new TextEditingController();
  String _userPhone                                 = '0899628974';
  String userAddress;

   @override
  void dispose() {
    super.dispose();
  }
 
  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  /**************************************************
   *                GOOGLE MAPS INIT        
   *************************************************/
  static final LatLng center = const LatLng( -6.914744, 107.609810);
  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;
  double latitudeFromString  = null;
  double longitudeFromString = null;
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(center.latitude, center.longitude),
    zoom: 10,
  );

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  void _addMarker(double latitude, double longitude, bool fromQueryString, String queryString) async {
    markers.clear();
    

    if(fromQueryString){
      //get address for type String to coordinate 
      var addresses           = await Geocoder.local.findAddressesFromQuery(queryString);
      var first               = addresses.first;  // print("${first.featureName} : ${first.coordinates} : ${first.addressLine}");
      setState(() {
        userAddress               = first.addressLine;
        userLocation['latitude']  = first.coordinates.latitude;
        userLocation['longitude'] = first.coordinates.longitude;
      });
    }else{
      //get address for type coordinate to String 
      final coordinates = new Coordinates(
              latitude == null ? center.latitude : latitude,
              longitude == null ? center.longitude : longitude
            );
      var addresses   = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first       = addresses.first;

      setState(() {
        userAddress = first.addressLine;
        userLocation['latitude']  = first.coordinates.latitude;
        userLocation['longitude'] = first.coordinates.longitude;
      });  // print(' ${first.locality}, ${first.adminArea}, ${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
                 _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      draggable: true,
      position: LatLng(
        latitude == null ? (fromQueryString == true) ? userLocation['latitude'] : center.latitude : latitude,
        longitude == null ? (fromQueryString == true) ? userLocation['longitude'] : center.longitude  : longitude,
      ),
      // infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        // _onMarkerDragEnd(markerId, position);
      },
    );


    setState(() {
        markers[markerId] = marker;
      });
      _stopSearching();
  }

  /**************************************************
   *                GOOGLE MAPS INIT        
   *************************************************/
  
 

  void _startSearch() async {
    ModalRoute
        .of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
    
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
    Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text('Checkout'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  Future<void> updateSearchQuery(String newQuery) async {
    setState(() {
      searchQuery = newQuery;
    });

    try{
      await Provider.of<MapsAutocomplete>(context).findAddress(context, newQuery, kGoogleApiKey);
    }catch (err){
      _alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
    }

  }

  List<Widget> _buildActions() {

    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () async {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
             
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: ()  {
          _startSearch();
        },
      ),
    ];
  }

  void _currentLocation() async {
      await Provider.of<User>(context).getLocation().then((value){
        setState(() {
            userLocation = value;
          });
          _addMarker(userLocation['latitude'], userLocation['longitude'], false, null);
        });
  }


  @override
  void didChangeDependencies() {
    if(_isInit){
      // for get location latitude longitude
     _currentLocation();

    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final itemCart            = Provider.of<CartItem>(context, listen: false); 
    final authUser            = Provider.of<Auth>(context, listen: false);
    final myWallet            = Provider.of<User>(context).myWallet;
    final deviceSize          = MediaQuery.of(context).size;
    final int itemLength      = itemCart.item.length;
    final recomendationAddress= Provider.of<MapsAutocomplete>(context).recomendAddress;

    if(itemLength < 5){
      _setHeigtItemList = 0.1;
    } else if (itemLength <= 10) {
      _setHeigtItemList = 0.15;
    } else if (itemLength <= 15) {
      _setHeigtItemList = 0.30;
    } else if (itemLength <= 20) {
      _setHeigtItemList = 0.40;
    } else if (itemLength <= 25) {
      _setHeigtItemList = 0.45;
    } else if (itemLength <= 30) {
      _setHeigtItemList = 0.50;
    } else if (itemLength <= 35) {
      _setHeigtItemList = 0.60;
    } else {
      _setHeigtItemList = 0.65;
    }

    return Scaffold(
      // key: scaffoldKey,
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
      ),
      body: 
      _isSearching 
      ?
      Container(
        height: double.infinity,
        child: 
        recomendationAddress.length == 0
        ?
        Center(
          child: Text('Address Not Found...'),
        )
        :
        ListView.builder(
          itemCount: recomendationAddress.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.place),
                title: Text('${recomendationAddress[index].description}'),
                onTap: (){
                  _addMarker(null, null, true, recomendationAddress[index].description);
                },
              )
            );
          },
        )
        // Column(
        //   children: <Widget>[
        //     Text('List Address', style: Theme.of(context).textTheme.title),
        //   ],
        // )
      )
      :
      AnimatedOpacity(
        opacity: _isSearching ? 0.0 : 1.0,
        duration: Duration(milliseconds: 2000),
        child: Container(
          height: deviceSize.height,
          child: Column(
            children: <Widget>[
              Container(
                height: deviceSize.height * 0.5,
                color: Colors.black.withOpacity(0.8),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                  // https://github.com/flutter/flutter/issues/28312
                  // ignore: prefer_collection_literals
                  markers: Set<Marker>.of(markers.values),
                  onTap: (val){
                    _addMarker(val.latitude, val.longitude, false, null);
                  },
                ),
              ),
              Container(
                height: deviceSize.height * 0.30,
                color: Colors.black.withOpacity(0.8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text('Order Detail', style: Theme.of(context).textTheme.title),
                      ),
                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Address', style: Theme.of(context).textTheme.title),
                                ],
                              ),
                              Divider(color: Colors.grey[100]),
                              Text('${userAddress}'),
                            ],
                          )
                        )
                      ),

                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Phone number', style: Theme.of(context).textTheme.title),
                                  SizedBox(
                                    width: 70,
                                    height: 20,
                                    child: FlatButton(
                                      child: Text('Edit', style: Theme.of(context).textTheme.title),
                                      onPressed: _showDialogPhone,
                                    ),
                                  )
                                ],
                              ),
                              Divider(color: Colors.grey[100]),
                              Text(_userPhone ),
                            ],
                          )
                        )
                      ),

                      Card(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Payment Detail', style: Theme.of(context).textTheme.title),
                                ],
                              ),
                              Divider(color: Colors.grey[100]),

                              /**
                              * List Order Item
                              */
                              Container(
                                height: deviceSize.height * _setHeigtItemList,
                                child: ListView.builder(
                                  itemCount: itemLength,
                                  itemBuilder: (BuildContext context, index) {
                                  return new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('${itemCart.item.values.toList()[index].name} X ${itemCart.item.values.toList()[index].quantity}', style: TextStyle(fontSize: 16)),
                                        Text('RM ${itemCart.item.values.toList()[index].subTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                                      ],
                                    );
                                  }
                                ),
                              ),
                            
                              /**
                              * Total Item
                              */
                              Divider(color: Colors.grey[100]),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Total', style: Theme.of(context).textTheme.title),
                                  Text('RM ${itemCart.getTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                              
                            ],
                          )
                          
                        )
                      ),

                      SizedBox(height: 80),

                    ],
                  ),
                ),
              ),
              
            ],
          )
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isSearching ? 0.0 : 1.0,
        duration: Duration(milliseconds: 5000),
        child : 
          _isSearching 
          ? 
          null 
          : 
          Container(
            width: deviceSize.width * 0.9,
            child: FloatingActionButton.extended(

              backgroundColor: _disabledButton ? Colors.grey : Colors.green,
              icon: Icon(Icons.attach_money, color: Colors.white,),
              label: Text('Buy', style: Theme.of(context).textTheme.headline),
              onPressed: _disabledButton ? null : (){

              _confirmModalBottom(
                  authUser.userId, 
                  '', 
                  userLocation['latitude'].toString(), 
                  userLocation['longitude'].toString(),
                  _userPhone,
                  myWallet, 
                  itemCart.getTotal,
                  itemCart.item.values.toList()
                );
              
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _confirmModalBottom(
    String userId, 
    String address, 
    String latitude,
    String longitude,
    String phone,
    double myWallet, 
    double totalPayment,
    List<Item> items
    ){

    double balanceUser = myWallet - totalPayment;
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (builder){
        return new Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            decoration: new BoxDecoration(
            color: Colors.black,
            borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(30.0),
            topRight: const Radius.circular(30.0))),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 3,
                  color: Colors.grey,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('My Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('RM ${myWallet.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total Payment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('RM ${totalPayment.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
                SizedBox(height: 5),
                Divider(color: Colors.grey),
                SizedBox(height: 5),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Balance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('RM ${balanceUser.toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
                SizedBox(height: 15),
                Text('(payment will be deducted from your wallet)', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 15),

                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  height: 45,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  buttonColor: Colors.green,
                  child: RaisedButton(
                    child: Text("Confirm", style: Theme.of(context).textTheme.title),
                    onPressed: () async {
                       setState(() {
                         _clickCount = _clickCount + 1;
                       });

                       if(_clickCount == 1){
                          try{

                          //processing order
                          await Provider.of<ItemOrders>(context, listen: false).addOrder(userId, userAddress, latitude, longitude, int.parse(phone), totalPayment.toStringAsFixed(2), items);
                          _alertDialogWithIcon(context, Icons.check_circle_outline, 'Confirmation', 'Congratulation payment success', false);


                          //clear cart item
                          Provider.of<CartItem>(context, listen: false).clearCartItem();
                          setState(() {
                            _disabledButton = true;
                            _clickCount     = 0;
                          });
                         
                        } on HttpException catch(err){
                          _alertDialogWithIcon(context, Icons.error_outline, 'Something wrong!', err.toString(), true);
                        }catch (err){
                          _alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
                        }

                       }
                        
                    },    
                  ),
                ),
              ],
            )
          ),
        );
      }
    );
  }

  Widget _alertDialogWithIcon(BuildContext context, IconData icon, String title, String messages, bool warning){
    showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0)),
            title: Container(
              child: Icon(icon, size: 100, color: warning ? Colors.red : Colors.green),
            ),
            content:Container(
              height: 150,
              child: Column(
                children: <Widget>[
                  Text(title, style: TextStyle(color: warning ? Colors.red : Colors.green, fontSize: 24)),
                  SizedBox(height: 20),
                  Text(messages, style: TextStyle(color: Colors.grey, fontSize: 16), textAlign: TextAlign.center,),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close', style: TextStyle(color: warning ? Colors.red : Colors.green)),
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HistoryOrdersScreen()));
                },
              )
            ],
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 500),
    barrierDismissible: false,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {});
  }

  Widget _showDialogPhone()  {
      showDialog<String>(
        context: context,
        builder: (context){
          return  AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: _phoneController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  style: new TextStyle(color: Colors.white),
                  decoration: new InputDecoration(
                      labelText: 'Phone Number', 
                      hintText: '+60 XXXX',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20)
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL', style: TextStyle(color: Colors.orange)),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Ok', style: TextStyle(color: Colors.white)),
                onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _userPhone = _phoneController.text;
                    });
                })
          ],
        );
      }
    );
  }
}

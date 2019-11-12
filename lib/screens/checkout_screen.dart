import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satay_meals/providers/auth.dart';
import 'dart:io';

import '../screens/payment_screen.dart';
import '../providers/cart_item.dart';
import '../providers/user.dart';
import '../providers/orders.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout-screen';
  
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> 
  with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchQuery;
  bool _isSearching                                 = false;
  String searchQuery                                = "Search query";
  double _setHeigtItemList                          = 0.1;
  var _isLoading                                    = false;
  var _isInit                                       = true;
  Map<String, double> userLocation;
  var _disabledButton                               = false;
  TextEditingController _phoneController            = new TextEditingController();
  String _userPhone                                 = '0899628974';

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  void _startSearch() {
    print("open search box");
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

  void updateSearchQuery(String newQuery) {

    setState(() {
      searchQuery = newQuery;
    });
    print("search query " + newQuery);

  }

  List<Widget> _buildActions() {

    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
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
        onPressed: _startSearch,
      ),
    ];
  }

  

  @override
  void didChangeDependencies() {
    if(_isInit){
      // for get location latitude longitude
      Provider.of<User>(context).getLocation().then((value){
          userLocation = value;
      });

    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final itemCart        = Provider.of<CartItem>(context, listen: false); 
    final authUser        = Provider.of<Auth>(context, listen: false);
    final myWallet        = Provider.of<User>(context).myWallet;

    final deviceSize      = MediaQuery.of(context).size;
    final int itemLength  = itemCart.item.length;

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

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // new Text(
            //   '$searchQuery',
            //   style: Theme.of(context).textTheme.display1,
            // ),

            Container(
              height: deviceSize.height * 0.3,
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Text('Ini Ceritanya Map, \n kata gobang'),
              ),
            ),

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
                    Text('Jl. Bojong Koneng Makmur Barat No.15 Kelurahan Sukapada Kecamatan Cibeunying Kidul Bandung 40125'),
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
      floatingActionButton: Container(
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
          height: MediaQuery.of(context).size.height * 0.35,
          child: Container(
            decoration: new BoxDecoration(
            color: Colors.white,
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
                    Text('My Wallet', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('RM ${myWallet.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey, fontSize: 20)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total Payment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('RM ${totalPayment.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey, fontSize: 20)),
                  ],
                ),
                SizedBox(height: 5),
                Divider(color: Colors.grey),
                SizedBox(height: 5),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Balance', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('RM ${balanceUser.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey, fontSize: 20)),
                  ],
                ),
                SizedBox(height: 15),
                Text('(payment will be deducated from your wallet)', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 15),

                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  height: 45,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  buttonColor: Colors.green,
                  child: RaisedButton(
                    child: Text("Confrim", style: Theme.of(context).textTheme.title),
                    onPressed: () async {
                       
                        try{

                          //processing order
                          await Provider.of<ItemOrders>(context, listen: false).addOrder(userId, 'jl BKM Barat no 123', latitude, longitude, int.parse(phone), totalPayment, items);
                          _showAlertDialog('Confirmation', 'Payment success', false);

                          setState(() {
                            _disabledButton = true;
                          });

                          //clear cart item
                          Provider.of<CartItem>(context, listen: false).clearCartItem();

                        } on HttpException catch(err){
                          _showAlertDialog('Something wrong!', err.toString(), true);
                        }catch (err){
                          _showAlertDialog('An error occured!', err, true);
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

  Widget _showAlertDialog(String title, String message, bool warning){
     showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: warning ? Colors.red : Colors.white)),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Close', style: TextStyle(color: Colors.orange)),
            onPressed: (){
                 
                Navigator.pop(context);
                Navigator.pop(context);
              
            },
          )
        ],
      )
    );
  }

  Widget _showDialogPhone()  {
     showDialog<String>(
      context: context,
      child: new AlertDialog(
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
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'dart:io';

import '../screens/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout-screen';
  
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> 
  with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
  new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "Search query";

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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
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
                        Text('Edit', style: Theme.of(context).textTheme.title)
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
                        Text('Edit', style: Theme.of(context).textTheme.title)
                      ],
                    ),
                    Divider(color: Colors.grey[100]),
                    Text('0899628974'),
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
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('10 X Chicken', style: TextStyle(fontSize: 16)),
                        Text('RM 12.0', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('10 X Chicken', style: TextStyle(fontSize: 16)),
                        Text('RM 12.0', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('10 X Chicken', style: TextStyle(fontSize: 16)),
                        Text('RM 12.0', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Divider(color: Colors.grey[100]),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total', style: Theme.of(context).textTheme.title),
                        Text('RM 12.0', style: TextStyle(fontSize: 18)),
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
          backgroundColor: Colors.green,
          icon: Icon(Icons.attach_money, color: Colors.white,),
          label: Text('Buy', style: Theme.of(context).textTheme.headline),
          onPressed: (){
            Navigator.of(context).pushNamed(PaymentScreen.routeName);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


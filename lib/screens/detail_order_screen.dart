import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satay_meals/providers/cart_item.dart';
import 'package:satay_meals/providers/http_exception.dart';
import 'dart:async';
import 'dart:convert';
import '../providers/orders.dart';
import '../widgets/custom_notification.dart';

class DetailOrder extends StatefulWidget {
  final String orderId;
  final String tableName;
  final String vendor;
  final String rider;

  const DetailOrder({
    Key key,
    @required this.orderId,
    @required this.tableName,
    this.vendor,
    this.rider
  }) : super(key: key);

  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  double _setHeigtItemList  = 0.1;
  var _isInit               = true;
  var _isLoading            = false;
  int itemLength            = 1;
  var _detail;
  Map<String, Order> _detailOrder    = {};

  Future<void> loadDetailOrder() async {
    setState(() {
      _isLoading = true;
    });

    try{
        //try for fetch data 
        await Provider.of<ItemOrders>(context).getDetailOrder(widget.orderId, widget.tableName)
        .then( (Object result){
           final responseData = json.decode(result);
          
          //init data to variable
            _detailOrder.putIfAbsent(
              'detail', () => Order(
                consumerId  : '',
                address     : responseData['data']['address'],
                phone       : int.parse(responseData['data']['phone']),
                latitude    : responseData['data']['operator_lat'],
                longitude   : responseData['data']['operator_lng'],
                total       : double.parse(responseData['data']['total']),
                item        : (responseData['data']['item'] as List<dynamic>).map( (items)=>
                  Item(
                    name    : items['name'],
                    price   : double.parse(items['price']),
                    quantity: int.parse(items['quantity'])
                    ),
                  ).toList()
              ));

              setState(() {
                _isLoading  = false;
              });

              _detail     = _detailOrder['detail'];
              itemLength  = _detail.item.length;
        });

    
    } on HttpException catch (err){
        CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Something wrong!', err.toString(), true);
    } catch (err){
        CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  void didChangeDependencies() {

      if(_isInit){
          _isLoading = true;
          _detailOrder = {};
          loadDetailOrder();
      }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
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
      appBar: AppBar(
        title: Text('Order Detail', style: Theme.of(context).textTheme.title),
      ),
      body: 
        _isLoading 
        ?
        Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
        :
        Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Card(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Kios Name :', style: Theme.of(context).textTheme.title),
                          Text('  ${widget.vendor}', style: Theme.of(context).textTheme.body1),
                          SizedBox(height: 15),
                          Text('Rider Name :', style: Theme.of(context).textTheme.title),
                          Text('  ${widget.rider}', style: Theme.of(context).textTheme.body1),
                          SizedBox(height: 15),
                          Text('Address :', style: Theme.of(context).textTheme.title),
                          Text('  ${_detail != null ? _detail.address : '' }', style: Theme.of(context).textTheme.body1),
                          SizedBox(height: 15),
                          Text('Phone Number :', style: Theme.of(context).textTheme.title),
                          Text('  ${_detail != null ? _detail.phone : ''}', style: Theme.of(context).textTheme.body1),
                        ],
                      ),
                    )
                  ),
              
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Payment Detail', style: Theme.of(context).textTheme.title),
                          Divider(color: Colors.white),
                          Container(
                            height: MediaQuery.of(context).size.height * _setHeigtItemList,
                            child: ListView.builder(
                              itemCount: itemLength,
                              itemBuilder: (BuildContext ctx, index){
                                return new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(' ${_detail != null ? _detail.item[index].quantity : ''} x ${_detail != null ? _detail.item[index].name : ''}', style: Theme.of(context).textTheme.body1),
                                    Text('RM  ${_detail != null ? _detail.item[index].price : ''}', style: Theme.of(context).textTheme.title),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Total Payment', style: Theme.of(context).textTheme.title),
                              Text('RM ${_detail != null ? _detail.total : 0}', style: Theme.of(context).textTheme.title),
                            ],
                          )
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}


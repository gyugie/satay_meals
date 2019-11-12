import 'package:flutter/material.dart';

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
  double _setHeigtItemList = 0.1;


  @override
  Widget build(BuildContext context) {
    final itemLength = 5;
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
      body: Container(
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
                        Text('  JL. XXX', style: Theme.of(context).textTheme.body1),
                        SizedBox(height: 15),
                        Text('Phone Number :', style: Theme.of(context).textTheme.title),
                        Text('  +60 XXXX', style: Theme.of(context).textTheme.body1),
                      ],
                    ),
                  )
                ),
             
                Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * _setHeigtItemList,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Payment Detail', style: Theme.of(context).textTheme.title),
                        Divider(color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('10 x Chicken', style: Theme.of(context).textTheme.body1),
                            Text('RM 12', style: Theme.of(context).textTheme.title),
                          ],
                        ),
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
                            Text('RM 12', style: Theme.of(context).textTheme.title),
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


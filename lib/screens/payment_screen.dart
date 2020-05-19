import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         iconTheme: new IconThemeData(color: Colors.orange[700]),
        title: Text('Confirm Payment', style: Theme.of(context).textTheme.headline),
      ),
      body: Container(
        width: double.infinity,
          child: Column(
            children: <Widget>[
              Card(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('My Wallet', style: Theme.of(context).textTheme.title),
                          Text('RM 9.12.12', style: Theme.of(context).textTheme.title)
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Total Payment', style: Theme.of(context).textTheme.title),
                          Text('RM 9.12', style: Theme.of(context).textTheme.title)
                        ],
                      ),
                      Divider(color: Colors.grey[100]),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Balance', style: Theme.of(context).textTheme.title),
                          Text('RM 19.00', style: Theme.of(context).textTheme.title)
                        ],
                      ),

                    ],
                  )
                )
              ),
            ],
          )
        ),
    );
  }
}
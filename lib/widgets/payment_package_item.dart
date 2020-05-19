import 'package:flutter/material.dart';

class PaymentPackage extends StatelessWidget {
  final String id;
  final String package;
  final double price;
  final double amount;
  final bool status;

  PaymentPackage({this.id, this.package, this.price, this.amount, this.status = false});

  @override
  Widget build(BuildContext context) {
    final mediaSize   = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      width: orientation == Orientation.portrait ? mediaSize.width : mediaSize.width * 0.5,
      padding: EdgeInsets.all(15),
      child:Container(
        width: mediaSize.width,
        height: mediaSize.height * 0.25,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(18)),
          image: DecorationImage(
            image: AssetImage('assets/images/world.jpeg'),
            fit: BoxFit.cover,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(),
                Container(
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Center(
                    child: Text('${package}', style: Theme.of(context).textTheme.title),
                  ),
                )
              ],
            ),
            Text('RM ${amount.toStringAsFixed(2)} ', style: TextStyle(color: Colors.white, fontSize: 30), textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Price : ', style: TextStyle(color: Colors.white, fontSize: 20)),
                    Text('   RM ${price.toStringAsFixed(2)} ', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
                SizedBox(
                  width: 110,
                  child: FlatButton(
                    color: Colors.orange[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('${status ? 'Pending' : 'Buy'}', style: Theme.of(context).textTheme.title),
                    onPressed: status ? null : (){
                      
                    },
                  )
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
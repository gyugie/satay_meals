import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentPackage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaSize   = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      width: mediaSize.width,
      padding: EdgeInsets.all(15),
      child:Container(
        width: mediaSize.width,
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
                    child: Text('C43', style: Theme.of(context).textTheme.title),
                  ),
                )
              ],
            ),
            Text('RM 12.0000.12 ', style: TextStyle(color: Colors.white, fontSize: 30), textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Price : ', style: TextStyle(color: Colors.white, fontSize: 20)),
                    Text('   RM 12.00 ', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: FlatButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Buy', style: Theme.of(context).textTheme.title),
                    onPressed: (){
                      
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
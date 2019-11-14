import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:satay_meals/widgets/payment_package_item.dart';
import '../widgets/drawer.dart';

class TopupScreen extends StatelessWidget {
  static const routeName = '/topup-screen';

  @override
  Widget build(BuildContext context) {
    final mediaSize   = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up', style: Theme.of(context).textTheme.title),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.transparent
       ),
       child: DrawerSide(),
      ),
      body: SingleChildScrollView(
        child: Container(
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text('Your Ballance', style: Theme.of(context).textTheme.title, textAlign: TextAlign.start,),
              ),
              Container(
                padding: EdgeInsets.all(20),
                height: orientation == Orientation.portrait ? mediaSize.height * 0.3 : mediaSize.height * 0.5,
                width: orientation == Orientation.portrait ? double.infinity :  mediaSize.width * 0.5,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('RM 12.0000.12 ', style: TextStyle(color: Colors.white, fontSize: 24)),
                          Container(
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                          )
                        ],
                      ),
                      Text('0000   ****   ****    0000 ', style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Mugy PLeci ', style: TextStyle(color: Colors.white, fontSize: 20)),
                          Text(DateFormat.yMMMd().format(DateTime.now()))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Purchase Package ', style: Theme.of(context).textTheme.title, textAlign: TextAlign.start,),
              ),
              SizedBox(height: 20),
              // for list payment card
              Container(
                height: orientation == Orientation.portrait ? mediaSize.height * 0.3 : mediaSize.height * 0.5,
                width: double.infinity,
                color: Colors.white.withOpacity(0.1),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (ctx, index) => PaymentPackage()
                )
              )
            ],
          ),
        ),
      ),
      
    );
  }
}
 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/history_order_screen.dart';
import '../widgets/verification_card.dart';
import '../providers/orders.dart';

class CustomNotif {


static void showAlertDialog(BuildContext context ,String title, String message, bool warning){
      showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: warning ? Colors.red : Colors.white)),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Close', style: TextStyle(color: Colors.orange)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      )
    );
  }

static void alertDialogWithIcon(BuildContext context, IconData icon, String title, String messages, bool warning, [bool doublePop = false]){
  
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
                  if(doublePop){
                    Navigator.pop(context, true);
                  }
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

static void alertDialogUserIsNotActive(BuildContext context, IconData icon, String title, String messages, bool isVerification){
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
            child: Icon(icon, size: 100, color: !isVerification ? Colors.red : Colors.green),
          ),
          content:Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Text(title, style: TextStyle(color: !isVerification ? Colors.red : Colors.green, fontSize: 24)),
                SizedBox(height: 20),
                Text(messages, style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
              ],
            ),
          ),
          actions: <Widget>[
            isVerification
            ?
              FlatButton(
              child: Text('Verification now!', style: TextStyle(color: Colors.green)),
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerificationCard()),
                  );
              },
            )
            :
            null,
            FlatButton(
              child: Text('Close', style: TextStyle(color: Colors.orange)),
              onPressed: (){
                Navigator.pop(context);
              },
            ),

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

static void alertVerification(BuildContext context, IconData icon, String title, String messages, bool isSuccess){
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
            child: Icon(icon, size: 100, color: !isSuccess ? Colors.red : Colors.green),
          ),
          content:Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Text(title, style: TextStyle(color: !isSuccess ? Colors.red : Colors.green, fontSize: 24)),
                SizedBox(height: 20),
                Text(messages, style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close', style: TextStyle(color: Colors.orange)),
              onPressed: () => Navigator.pop(context),
            ),
            isSuccess 
            ?
            FlatButton(
              child: Text('OK!', style: TextStyle(color: Colors.green)),
              onPressed: (){
                Navigator.pop(context);
                 Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                
              },
            )
            :
            null

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

static void alertComplainOrder(BuildContext context, IconData icon, String title, String messages, String orderID){
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
            child: Icon(icon, size: 100, color: Colors.red),
          ),
          content: Container(
            height: 150,
              child: SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  Text(title, style: TextStyle(color: Colors.red, fontSize: 24)),
                  SizedBox(height: 20),
                  Text(messages, style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,),
                ],
              ),
            )
          ),
          actions: <Widget>[
              FlatButton(
              child: Text('Yes!', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await Provider.of<ItemOrders>(context).cancelOrder(orderID);
                Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(HistoryOrdersScreen.routeName);
              },
            ),
            
            FlatButton(
              child: Text('No', style: TextStyle(color: Colors.green)),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),

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
}
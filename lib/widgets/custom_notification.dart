import 'package:flutter/material.dart';

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
}
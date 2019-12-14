import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:satay_meals/widgets/drawer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../providers/notification.dart';
import 'dart:io';
import 'dart:convert';
import '../local_notications_helper.dart';

class FirebaseNotificationScreen extends StatefulWidget {
  @override
  _FirebaseNotificationScreenState createState() => _FirebaseNotificationScreenState();
}

class _FirebaseNotificationScreenState extends State<FirebaseNotificationScreen> {
 final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();  
 List<RealTimeNotificaiton> notifications = [];  
@override  
void initState() {  
  super.initState();  
  _firebaseMessaging.configure(  
    onMessage: (Map<String, dynamic> notification) async {  
      setState(() {  
        notifications.add(  
          RealTimeNotificaiton(  
            title: notification["notification"]["title"],  
            body: notification["notification"]["body"],  
          ),  
        );  
      });  
    },  
    onLaunch: (Map<String, dynamic> notification) async {  
      setState(() {  
        notifications.add(  
          RealTimeNotificaiton(  
            title: notification["notification"]["title"],  
            body: notification["notification"]["body"],  
          ),  
        );  
      });  
    },  
    onResume: (Map<String, dynamic> notification) async {  
      setState(() {  
        notifications.add(  
          RealTimeNotificaiton(  
            title: notification["notification"]["title"],  
            body: notification["notification"]["body"],  
          ),  
        );  
      });  
    },  
  );  
}

 @override
  Widget build(BuildContext context) {
    // setState(() {
    //   notifications = [];
    // });
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notification', style: Theme.of(context).textTheme.title),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.transparent
       ),
       child: DrawerSide(),
      ),
      body: 
      notifications.length == 0
      ?
      Center(
        child: RaisedButton(
              child: Text('Show notification'),
              onPressed: () {

              }
            ),
        )
      :
      ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (ctx, index){
          return Container(
            child: Column(
              children: <Widget>[
                Text(notifications[index].title),
                Text(notifications[index].body),
              ],
            ),
          );
        },
      )
    );
  }
}
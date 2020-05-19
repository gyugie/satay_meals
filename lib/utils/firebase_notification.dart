import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:convert';

class RealTimeNotificaiton {
  final String title;
  final String body;

  const RealTimeNotificaiton({
    @required this.title,
    @required this.body
  });
  
}

List<RealTimeNotificaiton> messages         = [];  
final FirebaseMessaging _firebaseMessaging  = FirebaseMessaging();  
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final notifications = FlutterLocalNotificationsPlugin();


  Future initFirebase(context){
    print('object');
      //Init firebase notification
    _firebaseMessaging.configure(  
      onMessage: (Map<String, dynamic> notification) async {  
        final results = json.decode(notification['data']['data']);
        print("onMessage: ${results}");
        showOngoingNotification(notifications, title:  notification["notification"]["title"], body:  notification["notification"]["body"]);
        
      },  
      
      onLaunch: (Map<String, dynamic> notification) async {  
        final results = json.decode(notification['data']['data']);
        print("onLaunch: $results");
       
      },  
      onResume: (Map<String, dynamic> notification) async {  
        final results = json.decode(notification['data']['data']);
         print("onResume: ${results}");
        showOngoingNotification(notifications, title:  notification["notification"]["title"], body:  notification["notification"]["body"]);
        
      },  
    );  
    
  }
 
   NotificationDetails get _ongoing {
      final androidChannelSpecifics = AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ongoing: true,
        autoCancel: false,
      );
      final iOSChannelSpecifics = IOSNotificationDetails();
      return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
  }

   Future _showNotification(
    FlutterLocalNotificationsPlugin notifications, {
    @required String title,
    @required String body,
    @required NotificationDetails type,
    int id = 0,
  }) =>
      notifications.show(id, title, body, type);

   Future showOngoingNotification(
    FlutterLocalNotificationsPlugin notifications, {
    @required String title,
    @required String body,
    int id = 0,
  }) =>
      _showNotification(notifications,
          title: title, body: body, id: id, type: _ongoing);



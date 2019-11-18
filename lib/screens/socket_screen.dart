// import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
const String URI = 'https://adminbe.sw1975.com.my:3000/';

class SocketScreen extends StatefulWidget {
  static const routeName = '/socket-screen';
  @override
  _SocketScreenState createState() => _SocketScreenState();
}

class _SocketScreenState extends State<SocketScreen> {
    IO.Socket socket = IO.io(URI, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo':'bar'} // optional,
      
    });
  List _user = [];
  String temp;

  void initSocket() async {
   
  //  socket.on('connect', (_) {
  //    print('connect');
  //   //  socket.emit('send_loc', 'test');
  //   });
    socket.on('connect', (_) {
    
     socket.on('get_loc', (data)  {
        var stringMap =  data.cast<String, dynamic>();
          if(temp == stringMap['data']['name'].toString()){
            return;
          } else {
            setState(() {
              temp = stringMap['data']['name'];
            });
            _user.add({'date': stringMap['data']['name']});
          }
      });
      
    });
     
    socket.on('event', (data) => '');
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
    socket.connect();
  }
  // SocketIO socket;
  // SocketIOManager manager = SocketIOManager();
  
  // void initSocket() async  {
  //   print('init socket...');

  //   socket = await manager.createInstance(
  //     URI,
  //     enableLogging: true
  //   );

  //   socket.onConnect((data){
  //     print('connected!');
  //     print(data);

  //   });

  //   // socket.on('send_loc', (data){
  //   //   print('send_loc');
  //   // });

  //   socket.onDisconnect( (data){
  //     print('disconnect');
  //   });

  //   socket.onReconnect((data){
  //     print('reconnect');
  //   });

  //   socket.connect();

  //   socket.on('get_loc', (data){
  //     print('data +${data}');
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSocket();
  }


  sendMessage(){
    socket.emit('send_loc', [{'name': DateTime.now().toIso8601String()}]);
   
   
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: _user.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${_user.isEmpty ? '' : _user[index]['date']}...', style: TextStyle(color: Colors.green)),
                  );
                },
              ),
            ),
            FlatButton(
              child: Text('send Log'),
              onPressed: (){
                sendMessage();
              },
            ),
            FlatButton(
              child: Text('Clear Log'),
              onPressed: (){
                setState(() {
                  _user = [];
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
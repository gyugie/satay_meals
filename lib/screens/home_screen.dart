import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:satay_meals/screens/history_order_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


import '../utils/firebase_notification.dart';
import '../widgets/custom_notification.dart';
import '../widgets/product_list.dart';
import '../widgets/drawer.dart';
import '../providers/auth.dart';
import '../providers/products.dart';
import '../providers/user.dart';

const String URI = 'https://adminbe.sw1975.com.my:3000/';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var _isInit = true;
  var _isLoading = false;
  IO.Socket socket = IO.io(URI, <String, dynamic>{
    'transports': ['websocket'],
    'extraHeaders': {'foo':'bar'} // optional,
    
  });
  List _user = [];
  String temp;
  var ids = '26';

  @override  
  void initState() {  
    super.initState();  
    // initFirebase();
    new Future.delayed(Duration.zero,() {
      initFirebase(context);
    });
    initSocket();
     //Init local notification
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS     = IOSInitializationSettings(
          onDidReceiveLocalNotification: (id, title, body, payload) => onSelectNotification(payload));

          notifications.initialize(
              InitializationSettings(settingsAndroid, settingsIOS),
              onSelectNotification: onSelectNotification);

  }

  void initSocket()  {
    print('get_loc_'+ ids);
    socket.on('connect', (_) {
     socket.on('get_loc_'+ ids, (data)  {
        // var stringMap =  data.cast<String, dynamic>();
          // if(temp == stringMap['data']['name'].toString()){
          //   return;
          // } else {
          //   setState(() {
          //     temp = stringMap['data']['name'];
          //   });
          //     _user.add({'date': stringMap['data']['name']});
          // }
        print('user ${data}');

        });

        socket.on('client--left', (data) {
          print(data);
        });


      });
                 
      socket.on('event', (data) => print('disconnect'));
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
      socket.connect();
  }

  Future onSelectNotification(String payload) async {
    notifications.cancelAll(); 
    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoryOrdersScreen()),
      );
    });
  }

  Future<void> _loadDataHome() async {
     Future.wait([
           Provider.of<Products>(context).fetchFoods(),
           Provider.of<User>(context).getMyWallet(),
           Provider.of<User>(context).fetchUserProfile()
         ]).then( (List value) {
            setState(() {
              _isLoading = false;
            });
         }).catchError( (err){
            CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
         });
  }  

  @override
  void didChangeDependencies() {
    if(_isInit){
        _isLoading = true;
        _loadDataHome();
        socket.emit('room', '${ids}');

    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<Auth>(context, listen: false).role;
    final myWallet = Provider.of<User>(context, listen: false).myWallet;
   
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.green),
        actions: <Widget>[
            userRole == 'consumer' || userRole == 'vendor' 
            ? 
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('RM ${myWallet.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headline),
            )
            :
            null
        ],
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.transparent
       ),
       child: DrawerSide(),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: 
      /**
       * showing screen in accordance with the user role
       * consumer ProductList(),
       * courier OrderList(),
       * vendor OrderList(),
       */
      
      RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.green,
        onRefresh: _loadDataHome,
        child: _isLoading 
                ? 
                Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
                : 
                  (userRole == 'consumer' ) 
                  ? 
                  ProductList() 
                  : 
                  (userRole == 'courier') 
                  ? 
                  null 
                  : 
                  ProductList(), 
      )
    );
  }

  
}
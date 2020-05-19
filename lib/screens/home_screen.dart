import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:satay_meals/screens/history_order_screen.dart';

import '../utils/firebase_notification.dart';
import '../widgets/custom_notification.dart';
import '../widgets/product_list.dart';
import '../widgets/drawer.dart';
import '../providers/auth.dart';
import '../providers/products.dart';
import '../providers/user.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var _isInit = true;
  var _isLoading = false;
  AnimationController controller;
  Animation<double> animation;


  @override  
  void initState() {  
    super.initState();  
    // initFirebase();
    new Future.delayed(Duration.zero,() {
      initFirebase(context);
    });
     //Init local notification
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS     = IOSInitializationSettings(
          onDidReceiveLocalNotification: (id, title, body, payload) => onSelectNotification(payload));

          notifications.initialize(
              InitializationSettings(settingsAndroid, settingsIOS),
              onSelectNotification: onSelectNotification);

  }

  void animationTransition(){
    controller = AnimationController(
    duration: const Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInToLinear);

    controller.forward();
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
            Future.delayed(Duration(seconds: 3), (){
              setState(() {
                _isLoading = false;
                // animationTransition();
              });
            });
         }).catchError( (err){
            CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
         });
  }  

  @override
  void didChangeDependencies() {
    if(_isInit){
        _isLoading = true;
        animationTransition();
        _loadDataHome();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<Auth>(context, listen: false).role;
    final myWallet = Provider.of<User>(context, listen: false).myWallet;
    final deviceSize  = MediaQuery.of(context).size;

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
         canvasColor: Colors.black,
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
        child: 
                !_isLoading 
                ? 
                Container(
                  child: FadeTransition(
                      opacity: animation,
                      child: ProductList()
                      )
                  )
                : 
                Center(
                  child: FadeTransition(
                      opacity: animation,
                      child: Container(
                        height: deviceSize.height * 0.8,
                        width: deviceSize.width * 0.8,
                        child: Image.asset('assets/images/sate.gif'),
                    )
                  ),
                )
      )
    );
  }
}

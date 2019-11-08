import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_list.dart';
import '../widgets/drawer.dart';
import '../providers/auth.dart';
import '../providers/products.dart';
import '../providers/user.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var _isInit = true;
  var _isLoading = false;

  Future<bool> myTypedFuture() async {
    await Future.delayed(Duration(seconds: 3));
    print('Delay complete for Future 1');
    return true;
  }

   Future<bool> myTypedFuture2() async {
    await Future.delayed(Duration(seconds: 2));
    print('Delay complete for Future 2');
    return true;
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
       _isLoading = true;
     
         Future.wait([
           Provider.of<Products>(context).fetchFoods(),
           Provider.of<User>(context).getMyWallet()
         ]).then( (List value) {
            setState(() {
              _isLoading = false;
            });
         });
       
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
        actions: <Widget>[
            userRole == 'consumer' || userRole == 'vendor' 
            ? 
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('RM ${myWallet}', style: Theme.of(context).textTheme.headline),
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
        onRefresh: () {
           return Provider.of<Products>(context).fetchFoods();
        },
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
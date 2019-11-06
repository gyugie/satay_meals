import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_list.dart';
import '../widgets/drawer.dart';
import '../providers/auth.dart';
import '../providers/products.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if(_isInit){
       _isLoading = true;
       Provider.of<Products>(context).fetchFoods().then( (_){
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

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('RM 9.244.3', style: Theme.of(context).textTheme.headline),
            )
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
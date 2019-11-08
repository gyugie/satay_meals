import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/checkout_screen.dart';
import '../widgets/order_list.dart';
import '../providers/cart_item.dart';
import '../providers/user.dart';
import '../providers/auth.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if(_isInit){
      Provider.of<CartItem>(context).clearCartItem();
    }  
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
  final deviceSize  = MediaQuery.of(context).size;
  final cartItem    = Provider.of<CartItem>(context);
  final userRole    = Provider.of<Auth>(context, listen: false).role;
  final myWallet    = Provider.of<User>(context, listen: false).myWallet;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order', style: Theme.of(context).textTheme.headline),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: deviceSize.height * 0.78 ,
              child: OrderList()
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: deviceSize.width * 0.9,
        child: AnimatedOpacity(
          opacity: cartItem.item.length > 0 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 1000),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            label: Text('Checkout RM ${cartItem.getTotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.title),
            onPressed: (){
              Navigator.of(context).pushNamed(CheckoutScreen.routeName);
            },
          ),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satay_meals/widgets/custom_notification.dart';
import '../screens/checkout_screen.dart';
import '../widgets/order_list.dart';
import '../providers/cart_item.dart';
import '../providers/user.dart';
import '../providers/auth.dart';

class FailValidationQty {
  String name;
  int qtyOrder;
  int minOrder;

  FailValidationQty({this.name, this.minOrder, this.qtyOrder});
}

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  var _isInit = true;
  AnimationController controller;
  Animation<double> animation;

  List<FailValidationQty> _failValidationQty = [];

  _onCheckingMinOrder(BuildContext context){
      final itemCart = Provider.of<CartItem>(context);
      final limitRM = Provider.of<User>(context).limitRm;
      setState(() {
        _failValidationQty = [];
      });
     
      for(int i = 0; i < itemCart.item.length; i++){
        if(itemCart.item.values.toList()[i].quantity < itemCart.item.values.toList()[i].minOrder){
          _failValidationQty.add(
            FailValidationQty(
              name: itemCart.item.values.toList()[i].name,
              qtyOrder: itemCart.item.values.toList()[i].quantity,
              minOrder: itemCart.item.values.toList()[i].minOrder
            )
          );
        }
      }

      if(_failValidationQty.length > 0){
        showDialog(
           context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Please order minimum quantity', style: TextStyle(color: Colors.red )),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _failValidationQty.map((FailValidationQty value) => Text('Minimum quantity for ${value.name} is ${value.minOrder}')).toList(),
                )
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close', style: TextStyle(color: Colors.orange)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          );
      } else if(limitRM > double.parse(itemCart.getTotal.toStringAsFixed(2)) ){
        CustomNotif.alertDialogWithIcon(context, Icons.info_outline,'Use minimal RM', 'Minimum order amount less than RM  ${limitRM} Current total purchase RM ${itemCart.getTotal.toStringAsFixed(2)}', true);
      } else {
        Navigator.of(context).pushNamed(CheckoutScreen.routeName);
      }

  }

  void initState(){
    super.initState();
    controller = AnimationController(
    duration: const Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInToLinear);

    controller.forward();
  }

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
         iconTheme: new IconThemeData(color: Colors.orange[700]),
        title: Text('Order', style: Theme.of(context).textTheme.headline),
        actions: <Widget>[
             userRole == 'consumer' || userRole == 'vendor' 
            ? 
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Icon(Icons.account_balance_wallet, color: Colors.white),
                  SizedBox(width: 5),
                  Text('RM ${myWallet.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headline),
                ],
              )
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
                  child: FadeTransition(
                    opacity: animation,
                    child: OrderList()
                  ),
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
              backgroundColor: Colors.orange[700],
              label: Text('Checkout RM ${cartItem.getTotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.title),
              onPressed: cartItem.item.length < 1 ? null : (){
                _onCheckingMinOrder(context);
              },
            ),
          )
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
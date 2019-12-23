import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../providers/http_exception.dart';
import '../widgets/custom_notification.dart';
import '../providers/orders.dart';
import '../widgets/history_order_item.dart';
import '../widgets/drawer.dart';

class HistoryOrdersScreen extends StatefulWidget {
  static const routeName = '/history-orders';
  @override
  _HistoryOrdersScreenState createState() => _HistoryOrdersScreenState();
}

class _HistoryOrdersScreenState extends State<HistoryOrdersScreen> {
    var _isInit = true;
    var _isLoading = false;

  Future<void> _loadHistoryOrder() async {
     try{
      await Provider.of<ItemOrders>(context).getHistoryOrders();
     } catch (err) {
       CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
     }

     setState(() {
       _isLoading = false;
     });
  }

  Future<void> confirmOrder(String orderID) async {
    try{
      await Provider.of<ItemOrders>(context).confirmOrder(orderID);
      _loadHistoryOrder();
    } on HttpException catch(err){
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Something wrong', err.toString(), true);
     } catch (err) {
       CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
     }
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
    _isLoading = true;
     _loadHistoryOrder();
    }
    
    _isInit = false;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
   final historyOrders = Provider.of<ItemOrders>(context, listen: false).history;
    return Scaffold(
      appBar: AppBar(
        title: Text('History Oder', style: Theme.of(context).textTheme.title),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.transparent
       ),
       child: DrawerSide(),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: _loadHistoryOrder,
          child: 
          _isLoading 
          ? 
          Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
          :
            historyOrders.length == 0
            ?
            Center(
              child: Image.asset('assets/images/cartempty.png', height: 100),
            )
            :
          ListView.builder(
            itemCount: historyOrders.length,
            itemBuilder: (ctx, index) => HistoryItem(
              noTransaction: historyOrders[index].noTransaction,
              orderId: historyOrders[index].orderId,
              createdAt: historyOrders[index].createdAt,
              statusOrder: historyOrders[index].statusOrder,
              total: historyOrders[index].total,
              tableName: historyOrders[index].tableName,
              vendor: historyOrders[index].vendor,
              rider: historyOrders[index].rider,
              confirmOrder: confirmOrder,
            ),
          ),
        )
      )
    );
  }
}
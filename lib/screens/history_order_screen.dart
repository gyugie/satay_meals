import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
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
       throw err;
     }

     setState(() {
       _isLoading = false;
     });
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
            ),
          ),
        )
      )
    );
  }
}
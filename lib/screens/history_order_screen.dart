import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

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
      Future.delayed(Duration(seconds: 3), (){
        setState(() {
          _isLoading = false;
        });
      });
     } catch (err) {
       CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
     }

     
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
   final deviceSize  = MediaQuery.of(context).size;
   final orientation       = MediaQuery.of(context).orientation;

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
          !_isLoading 
          ? 
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
          )
          :
            historyOrders.length == 0
            ?
            Center(
              child: Image.asset('assets/images/cartempty.png', height: 100),
            )
            :
          // Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
          ListView.builder(
            itemCount: 3,
            itemBuilder: (ctx, index){
              return  Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Card(
                    elevation: 5,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[700],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: orientation == Orientation.portrait ? deviceSize.height * 0.25 : deviceSize.height * 0.4 ,
                        padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: deviceSize.width * 0.45,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          width: deviceSize.width * 0.10,
                                          height: 20.0,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),                  
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: deviceSize.width * 0.30,
                                    height: 20.0,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    width: deviceSize.width * 0.30,
                                    height: 20.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Container(
                                    width: deviceSize.width * 0.40,
                                    height: 20.0,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    width: deviceSize.width * 0.15,
                                    height: 20.0,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      )
                    )
                  );
              }),
        )
      )
    );
  }
}
// Container(
//             padding: EdgeInsets.only(top: 10),
//             child: Card(
//               elevation: 5,
//               child: Shimmer.fromColors(
//               baseColor: Colors.grey[700],
//               highlightColor: Colors.grey[100],
//               child: Container(
//               height: orientation == Orientation.portrait ? deviceSize.height * 0.25 : deviceSize.height * 0.4 ,
//               padding: EdgeInsets.all(15),
//                 child: Column(
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Container(
//                           width: deviceSize.width * 0.45,
//                           height: 30,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             color: Colors.white,
//                           ),
//                         ),
//                         Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget>[
//                               Container(
//                                 width: deviceSize.width * 0.10,
//                                 height: 20.0,
//                                 color: Colors.white,
//                               ),
//                             ],
//                           ),
//                         ),                  
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Container(
//                           width: deviceSize.width * 0.30,
//                           height: 20.0,
//                           color: Colors.white,
//                         ),
//                         Container(
//                           width: deviceSize.width * 0.15,
//                           height: 20.0,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                           Container(
//                           width: deviceSize.width * 0.40,
//                           height: 20.0,
//                           color: Colors.white,
//                         ),
//                         Container(
//                           width: deviceSize.width * 0.15,
//                           height: 20.0,
//                           color: Colors.white,
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             )
//             )
//           )
//         )
//       )
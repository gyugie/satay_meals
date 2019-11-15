import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/http_exception.dart';
import '../widgets/custom_notification.dart';
import '../widgets/drawer.dart';
import '../widgets/payment_package_item.dart';
import '../providers/topup.dart';

class TopupPendingScreen extends StatefulWidget {
  static const routeName = '/topup-pending';
  @override
  _TopupPendingScreenState createState() => _TopupPendingScreenState();
}

class _TopupPendingScreenState extends State<TopupPendingScreen> {
  var _isInit     = true;
  var _isLoading  = false;

  Future<void> _loadPendingTopup() async {
    try{
      await Provider.of<SatayTopup>(context).fetchPendingTopup();
      setState(() {
        
        _isLoading        = false;
      });
    } on HttpException catch(err) {
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Something wrong!', err.toString(), true);
    } catch (err){
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
    }
   
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      _isLoading = true;
      _loadPendingTopup();
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final _listPendingTopup = Provider.of<SatayTopup>(context, listen: false).pendingPurchasePackage;
    return Scaffold(
      appBar: AppBar(
        title: Text('Topup Pending', style: Theme.of(context).textTheme.title),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.transparent
       ),
       child: DrawerSide(),
      ),
      body: RefreshIndicator(
        onRefresh: _loadPendingTopup,
        child: Container(
          child: 
          _isLoading 
          ?
          Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
          :
          _listPendingTopup.isEmpty
          ?
          Center(
            child: Text('You don`t have a pending payment...', style: Theme.of(context).textTheme.title)
          )
          :
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _listPendingTopup.length,
            itemBuilder: (ctx, index) => PaymentPackage(
              id: _listPendingTopup[index].id,
              package: _listPendingTopup[index].package,
              amount: _listPendingTopup[index].amount,
              price: _listPendingTopup[index].price,
              status: true,
            )
          )
        ),
      )
    );
  }
}
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

class _TopupPendingScreenState extends State<TopupPendingScreen> with TickerProviderStateMixin {
  var _isInit     = true;
  var _isLoading  = false;
  AnimationController controller;
  Animation<double> animation;

   void animationTransition(){
    controller = AnimationController(
    duration: const Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInToLinear);

    controller.forward();
  }

  Future<void> _loadPendingTopup() async {
    try{
      await Provider.of<SatayTopup>(context).fetchPendingTopup();
      Future.delayed(Duration(seconds: 2), (){
          setState(() {
            _isLoading        = false;
            animationTransition();
          });
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
      animationTransition();
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize        = MediaQuery.of(context).size;
    final _listPendingTopup = Provider.of<SatayTopup>(context, listen: false).pendingPurchasePackage;
    
    return Scaffold(
      appBar: AppBar(
         iconTheme: new IconThemeData(color: Colors.green),
        title: Text('Topup Pending', style: Theme.of(context).textTheme.title),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.black.withOpacity(0.5)
       ),
       child: DrawerSide(),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: RefreshIndicator(
        onRefresh: _loadPendingTopup,
        child: Container(
          child: 
          _isLoading 
          ?
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
          :
          _listPendingTopup.isEmpty
          ?
          Center(
            child: Image.asset('assets/images/cartempty.png', height: 100),
          )
          :
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _listPendingTopup.length,
            itemBuilder: (ctx, index) => FadeTransition(
              opacity: animation,
              child: PaymentPackage(
                id: _listPendingTopup[index].id,
                package: _listPendingTopup[index].package,
                amount: _listPendingTopup[index].amount,
                price: _listPendingTopup[index].price,
                status: true,
              )
            )
          )
        ),
      )
    );
  }
}
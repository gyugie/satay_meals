import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:satay_meals/providers/http_exception.dart';
import 'package:satay_meals/widgets/custom_notification.dart';

import '../widgets/payment_package_item.dart';
import '../widgets/drawer.dart';
import '../providers/topup.dart';
import '../providers/user.dart';

class TopupScreen extends StatefulWidget {
  static const routeName = '/topup-screen';
  @override
  _TopupScreenState createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  var _isLoading  = false;
  var _isInit     = true;

  _loadListTopupSatay() async {
    try{
        await Provider.of<SatayTopup>(context).fetchListTopup();
        setState(() {
          _isLoading = false;
        });
     } on HttpException catch (err){
      CustomNotif.showAlertDialog(context, 'Something is wrong!', err.toString(), true);
    } catch (err) {
      CustomNotif.showAlertDialog(context, 'An error occured!', err.toString(), true);
    }
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      _isLoading = true;
      _loadListTopupSatay();
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final mediaSize   = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final listPackage = Provider.of<SatayTopup>(context).packagePurchase;
    final userBallance= Provider.of<User>(context).myWallet;

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up', style: Theme.of(context).textTheme.title),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.transparent
       ),
       child: DrawerSide(),
      ),
      body: SingleChildScrollView(
        child: Container(
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text('Your Ballance', style: Theme.of(context).textTheme.title, textAlign: TextAlign.start,),
              ),
              Container(
                padding: EdgeInsets.all(20),
                height: orientation == Orientation.portrait ? mediaSize.height * 0.3 : mediaSize.height * 0.5,
                width: orientation == Orientation.portrait ? double.infinity :  mediaSize.width * 0.5,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('RM ${userBallance.toStringAsFixed(2)} ', style: TextStyle(color: Colors.white, fontSize: 24)),
                          Container(
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                          )
                        ],
                      ),
                      Text('0000   ****   ****    0000 ', style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Mugy PLeci ', style: TextStyle(color: Colors.white, fontSize: 20)),
                          Text(DateFormat.yMMMd().format(DateTime.now()))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Purchase Package ', style: Theme.of(context).textTheme.title, textAlign: TextAlign.start,),
              ),
              // for list payment card
              SizedBox(height: 20),
              Container(
                height: orientation == Orientation.portrait ? mediaSize.height * 0.3 : mediaSize.height * 0.5,
                width: double.infinity,
                color: Colors.white.withOpacity(0.1),
                child: 
                _isLoading
                ?
                Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)))
                :
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listPackage.length,
                  itemBuilder: (ctx, index) => PaymentPackage(
                    id: listPackage[index].id,
                    package: listPackage[index].package,
                    amount: listPackage[index].amount,
                    price: listPackage[index].price,
                    status: false,
                  )
                )
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Currency fluctuation, bank or convenience fee and  applicable  taxes charge by both the seller and payment gateway may increase your final amount.\n Check payment gateway terms and conditions. \n \n By tapping Buy, you accept the following terms of service \n', 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}
 

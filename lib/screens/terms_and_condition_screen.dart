import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../widgets/custom_notification.dart';
import '../widgets/drawer.dart';
import '../providers/http_exception.dart';
import '../providers/user.dart';

class TermsAndConditionScreen extends StatefulWidget {
  static const routeName = '/terms-and-condition';
  @override
  _TermsAndConditionScreenState createState() => _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  var _isInit       = true;
  var _isLoading    = false;
  var _termsAndCondition;

  _loadTermsAndCondition() async {
     try{
       await Provider.of<User>(context).getTermsAndCondition()
       .then((Object results){
         final responseData = json.decode(results);
          setState(() {
            _isLoading          = false;
            _termsAndCondition  = responseData['data']; 
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
      _loadTermsAndCondition();
    }  
    _isInit = false;
    super.didChangeDependencies();
  }  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms And Condition', style: Theme.of(context).textTheme.title),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.transparent
       ),
       child: DrawerSide(),
      ),
      body: Center(
        child: 
        _isLoading 
        ? 
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)) 
        :  
        Container(
          padding: EdgeInsets.all(20),
          child: Text(_termsAndCondition, style: Theme.of(context).textTheme.body1, textAlign: TextAlign.center,)
        )
        ,
      ),
    );
  }
}
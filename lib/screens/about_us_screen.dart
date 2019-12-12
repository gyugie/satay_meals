import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../widgets/custom_notification.dart';
import '../widgets/drawer.dart';
import '../providers/http_exception.dart';
import '../providers/user.dart';

class AboutUsScreen extends StatefulWidget {
  static const routeName = '/aboutUs';
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  var _isInit       = true;
  var _isLoading    = false;
  var _aboutUs;

  _loadTermsAndCondition() async {
     try{
       await Provider.of<User>(context).getAboutUs()
       .then((Object results){
         final responseData = json.decode(results);
          setState(() {
            _isLoading          = false;
            _aboutUs  = responseData['data']; 
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
      iconTheme: new IconThemeData(color: Colors.green),
        title: Text('About Us', style: Theme.of(context).textTheme.title),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.transparent
       ),
       child: DrawerSide(),
      ),
      body: 
        _isLoading 
        ? 
        Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)) )
        : 
        Container(
          padding: EdgeInsets.all(20),
          child: Text(_aboutUs, style: Theme.of(context).textTheme.body1, textAlign: TextAlign.justify,)
      ),
    );
  }
}
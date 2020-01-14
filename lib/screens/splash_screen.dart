import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satay_meals/screens/auth_screen.dart';
import 'dart:async';

import '../screens/home_screen.dart';
import '../providers/auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _isInit = true;
  
  void checkingUserSession() async {
    Future.delayed(Duration(seconds:  3), (){
      final isAuth = Provider.of<Auth>(context).isAuth;
        if(isAuth){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
        } 
        // else {
        //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AuthScreen()));
        //   Provider.of<Auth>(context).logout();
        //   Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        // }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_isInit){
      checkingUserSession();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: deviceSize.height * 0.4,
                width: deviceSize.width * 0.6,
                child: Image.asset('assets/images/SWlogo.png', fit: BoxFit.fitWidth),
            ),
            Text('Satay Warior 1975', style: Theme.of(context).textTheme.title)

          ],
        )
      )
    );
  }
}
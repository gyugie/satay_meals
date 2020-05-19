import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

import '../widgets/custom_notification.dart';
import '../widgets/drawer.dart';
import '../providers/http_exception.dart';
import '../providers/user.dart';
import '../screens/home_screen.dart';

class AboutUsScreen extends StatefulWidget {
  static const routeName = '/aboutUs';
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>  with TickerProviderStateMixin {
  var _isInit       = true;
  var _isLoading    = false;
  var _aboutUs;
  AnimationController controller;
  Animation<double> animation;

  void animationTransition(){
    controller = AnimationController(
    duration: const Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInToLinear);

    controller.forward();
  }

  _loadTermsAndCondition() async {
     try{
       await Provider.of<User>(context).getAboutUs()
       .then((Object results){
         final responseData = json.decode(results);
           Future.delayed(Duration(seconds: 3), (){
            setState(() {
              _isLoading  = false;
              _aboutUs    = responseData['data']; 
              animationTransition();
            });
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
       animationTransition();
    }  
    _isInit = false;
    super.didChangeDependencies();
  }  
  @override
  Widget build(BuildContext context) {
    final deviceSize  = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
      iconTheme: new IconThemeData(color: Colors.green),
        title: Text('About Us', style: Theme.of(context).textTheme.title),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.black.withOpacity(0.5)
       ),
       child: DrawerSide(),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: 
        !_isLoading 
        ? 
        FadeTransition(
          opacity: animation,
          child: SingleChildScrollView(
            child: Container(
            padding: EdgeInsets.all(20),
            child:  Html(
                data: _aboutUs,
                defaultTextStyle: TextStyle(color: Colors.white),
                
                padding: EdgeInsets.all(8.0),
                onLinkTap: (url) {
                  print("Opening $url...");
                },
                customRender: (node, children) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "custom_tag": // using this, you can handle custom tags in your HTML 
                        return Column(children: children);
                    }
                  }
                },
              ),
           )
          )
        )
        : 
        // Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)) )
       FadeTransition(
          opacity: animation,
          child: Center(
          child: Container(
            height: deviceSize.height * 0.8,
            width: deviceSize.width * 0.8,
            child: Image.asset('assets/images/sate.gif'),
          ),
        )
       )
    );
  }
}
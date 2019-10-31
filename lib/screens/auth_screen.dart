import 'package:flutter/material.dart';
import '../widgets/signup_card.dart';
import '../widgets/login_card.dart';

enum AuthMode { Signin, Signup}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin{
  TabController _tabController;
  AuthMode _authMode  = AuthMode.Signin;
  var _flexForCard    = 2;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(initialIndex: 0 ,length: 2, vsync: this);
    _tabController.animateTo(0, curve: Curves.easeOutCirc, duration: Duration(milliseconds: 10000));

  }

  
  void _switchAuthMode(int number){
    // 0 for Signin && 1 for Signup
    if(number == 0){
      setState(() {
        _authMode     = AuthMode.Signup;
        _flexForCard  = 2;
      });
    } else {
      setState(() {
        _authMode       = AuthMode.Signin;
         _flexForCard   = 5;
      });
    }

  }

  _onDragStart(BuildContext context, DragStartDetails start){
   
  }


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                 Flexible(
                   child:  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Image.asset('assets/images/SWlogo.png',scale: 1.5,)
                  ),
                 ),
                 Flexible(
                   flex: deviceSize.width > 600 ? 2 : 1,
                   child: Container(
                     width: deviceSize.width * 0.8,
                     decoration: BoxDecoration(
                       color: Colors.blueGrey,
                       borderRadius: BorderRadius.circular(30)
                     ),
                      child: TabBar(
                        unselectedLabelColor: Colors.white,
                        indicatorColor: Colors.transparent,
                        labelColor: Colors.black,
                        indicator: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueGrey,
                            width: 5.0,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white
                        ),
                        controller: _tabController,
                        onTap: (index){
                          _switchAuthMode(index);
                        },
                        tabs:[
                          Tab(
                            child: Text('Sign in'),
                          ),
                          Tab(
                            child: Text('Sign up'),
                          ),
                        ],
                      ),
                   ),
                 ),
                 
                 Flexible(
                  flex: deviceSize.width > 600 ? 3 : _flexForCard,
                   child: Container(
                     padding: EdgeInsets.only(top: 20),
                     width: deviceSize.width * 0.8,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          GestureDetector(
                            child: LoginCard(),
                            onHorizontalDragStart: (DragStartDetails start) => _onDragStart(context, start),
                          ),
                          GestureDetector(
                            child: SignUp(),
                            onHorizontalDragStart: (DragStartDetails start) => _onDragStart(context, start),
                          ),
                        ],
                      )
                    ),
                  ),
              
                ],
              ),
            ),
          )
        ],
      ),  
    );
  }
}
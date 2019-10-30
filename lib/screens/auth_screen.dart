import 'package:flutter/material.dart';
import '../widgets/auth_card.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
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
                        tabs:[
                          Tab(
                            child:  Text('Sign in')
                          ),
                          Tab(
                            child: Text('Sign up'),
                          ),
                        ],
                      ),
                   ),
                 ),
                 Flexible(
                  flex: deviceSize.width > 600 ? 3 : 2,
                   child: Container(
                     padding: EdgeInsets.only(top: 20),
                     width: deviceSize.width * 0.8,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                        AuthCard(),
                        Icon(Icons.directions_transit),
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/profile_screen.dart';
import '../screens/about_us_screen.dart';
import '../screens/home_screen.dart';
import '../screens/terms_and_condition_screen.dart';
import '../screens/topup_pending.dart';
import '../screens/topup_screen.dart';
import '../screens/history_order_screen.dart';
import '../providers/auth.dart';
import '../providers/user.dart';

class DrawerSide extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   final getToken = Provider.of<Auth>(context);
    var _get              = Provider.of<User>(context, listen: false).userProfile;
    var _user             = _get['userProfile'];
   print(getToken.token);
   print(getToken.userId);
    return Drawer(
      child: Consumer<Auth>(
          builder: (ctx, authData, child) => ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('${_user == null ? '-' : (_user.username == '') ? 'not set' : _user.username }', style: Theme.of(context).textTheme.title),
              accountEmail: Text('${_user == null ? '-' : (_user.email != '') ? _user.email : 'not set'  }', style: Theme.of(context).textTheme.subtitle),
              currentAccountPicture: Image.asset('assets/images/1Stop_Consumer_favicon.png', fit: BoxFit.fitWidth),
              decoration: BoxDecoration(color: Colors.black),
            ),
            if(authData.role == 'consumer')
            _menuForConsumer(context),      
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Logout', style: Theme.of(context).textTheme.body1),
              onTap: (){
                  
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                Provider.of<Auth>(context).logout();

              },
            ),     
          ],
        ),
      ),
    );
  }

  Widget _menuForConsumer(BuildContext context){
    return Column(
      children: <Widget>[
         ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text('My Profile', style: Theme.of(context).textTheme.body1),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(UserProfile.routeName);
                //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SocketScreen()));
              },
            ),
        ListTile(
              leading: Icon(Icons.restaurant, color: Colors.white),
              title: Text('Purchase', style: Theme.of(context).textTheme.body1),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
              },
            ),
        ListTile(
              leading: Icon(Icons.credit_card, color: Colors.white),
              title: Text('Top Up', style: Theme.of(context).textTheme.body1),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(TopupScreen.routeName);
              },
            ),
        ListTile(
              leading: Icon(Icons.redeem, color: Colors.white),
              title: Text('Top Up Pending', style: Theme.of(context).textTheme.body1),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(TopupPendingScreen.routeName);
              },
            ),
        ListTile(
              leading: Icon(Icons.replay_10, color: Colors.white),
              title: Text('Orders History', style: Theme.of(context).textTheme.body1),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(HistoryOrdersScreen.routeName);
              },
            ),
        ListTile(
              leading: Icon(Icons.help_outline, color: Colors.white),
              title: Text('Terms and Conditions', style: Theme.of(context).textTheme.body1),
              onTap: (){
                 Navigator.of(context).pushReplacementNamed(TermsAndConditionScreen.routeName);
              },
            ),
        ListTile(
              leading: Icon(Icons.info_outline, color: Colors.white),
              title: Text('About Us', style: Theme.of(context).textTheme.body1),
              onTap: (){
                 Navigator.of(context).pushReplacementNamed(AboutUsScreen.routeName);
              },
            ),
//         ListTile(
//             leading: Icon(Icons.info_outline, color: Colors.white),
//             title: Text('Notificaiton', style: Theme.of(context).textTheme.body1),
//             onTap: (){
//                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FirebaseNotificationScreen()));
// // Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) => LocalNotificationWidget()));
//             },
//           ),
        ],
    );
  }
}
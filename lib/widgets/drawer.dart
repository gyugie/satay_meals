import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class DrawerSide extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   final getToken = Provider.of<Auth>(context).token;
   print(getToken);
    return Drawer(
      child: Consumer<Auth>(
          builder: (ctx, authData, child) => ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage('assets/images/SWlogo.png')
                )
              ),
              accountName: Text('Gyugie', style: Theme.of(context).textTheme.title),
              accountEmail: Text('mugypleci@gmail.com', style: Theme.of(context).textTheme.subtitle),
            ),

            if(authData.role == 'consumer')
            _menuForConsumer(context),      
            if(authData.role == 'courier')
            _menuForCourier(context),      
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Logout', style: Theme.of(context).textTheme.title),
              onTap: (){
                Navigator.of(context).pop();
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
              title: Text('My Profile', style: Theme.of(context).textTheme.title),
              onTap: (){

              },
            ),
        // Divider(color: Colors.white),
        ListTile(
              leading: Icon(Icons.restaurant, color: Colors.white),
              title: Text('Buy Satay', style: Theme.of(context).textTheme.title),
              onTap: (){

              },
            ),
        // Divider(color: Colors.white),
        ListTile(
              leading: Icon(Icons.credit_card, color: Colors.white),
              title: Text('Top Up', style: Theme.of(context).textTheme.title),
              onTap: (){

              },
            ),
        // Divider(color: Colors.white),
        ListTile(
              leading: Icon(Icons.redeem, color: Colors.white),
              title: Text('Pending Top Up', style: Theme.of(context).textTheme.title),
              onTap: (){

              },
            ),
        // Divider(color: Colors.white),
        ListTile(
              leading: Icon(Icons.replay_10, color: Colors.white),
              title: Text('History Orders', style: Theme.of(context).textTheme.title),
              onTap: (){

              },
            ),
        // Divider(color: Colors.white),
        ListTile(
              leading: Icon(Icons.help_outline, color: Colors.white),
              title: Text('Terms and Conditions', style: Theme.of(context).textTheme.title),
              onTap: (){

              },
            ),
        // Divider(color: Colors.white),
        ListTile(
              leading: Icon(Icons.info_outline, color: Colors.white),
              title: Text('About Orders', style: Theme.of(context).textTheme.title),
              onTap: (){

              },
            ),
        // Divider(color: Colors.white),
      ],
    );
  }

  Widget _menuForCourier(BuildContext context){
    return Column(
      children: <Widget>[
         ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text('My ', style: Theme.of(context).textTheme.title),
              onTap: (){

              },
            ),
        Divider(color: Colors.white),
        ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text('My ', style: Theme.of(context).textTheme.title),
              onTap: (){

              },
            ),
        Divider(color: Colors.white)
      ],
    );
  }
}
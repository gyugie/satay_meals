import 'package:flutter/material.dart';
import '../widgets/custom_notification.dart';
import '../widgets/profile_edit.dart';
import '../widgets/drawer.dart';

class UserProfile extends StatelessWidget {
  static const routeName = '/user-profile';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.title),
        elevation: 0.0,
        backgroundColor: Colors.black.withOpacity(0.03),
        iconTheme: new IconThemeData(color: Colors.green),
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
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: orientation == Orientation.portrait ? deviceSize.height * 0.25 : deviceSize.height * 0.6,
                child: Center(
                  child: Container(
                    width: 160.0,
                    height: 160.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 30.0, // has the effect of softening the shadow
                          spreadRadius: 3.0, // has the effect of extending the shadow
                          offset: Offset(
                            3.0, // horizontal, move right 5
                            3.0, // vertical, move down 15                          
                          ),
                        )
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://cdn0-production-images-kly.akamaized.net/2RsrPj4tFKF2R_qRXL8wdlgqGOw=/640x360/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/1871456/original/078916900_1517919090-Jun-Ji-Hyun-3.jpg')
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(160)),
                      color: Colors.redAccent,
                    ),
                  ),
                )
              ),
              Center(
                child: Text('Pacar Orang', style: Theme.of(context).textTheme.title)
              ),
              SizedBox(height: 10),
              Center(
                child: Text('Dia nya dia', style: Theme.of(context).textTheme.subtitle)
              ),
              SizedBox(height: 20),
              Divider(color: Colors.green),
              Container(
                height: deviceSize.height * 0.52,
                child: SingleChildScrollView(
                  child: Column(
                  children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.grey),
                        title: Text('mugypleci@gmail.com', style: Theme.of(context).textTheme.subtitle),
                      ),
                      Divider(color: Colors.green),
                       ListTile(
                        leading: Icon(Icons.lock, color: Colors.grey),
                        title: Text('******', style: Theme.of(context).textTheme.subtitle),
                        trailing: Icon(Icons.open_in_new),
                        onTap: (){
                          _changePasswordModal(context);
                        },
                      ),
                      Divider(color: Colors.green),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.grey),
                        title: Text('089666528074', style: Theme.of(context).textTheme.subtitle),
                      ),
                      Divider(color: Colors.green),
                      ListTile(
                        leading: Icon(Icons.account_balance, color: Colors.grey),
                        title: Text('West Java', style: Theme.of(context).textTheme.subtitle),
                      ),
                      Divider(color: Colors.green),
                      ListTile(
                        leading: Icon(Icons.business, color: Colors.grey),
                        title: Text('Bandung', style: Theme.of(context).textTheme.subtitle),
                      ),
                      Divider(color: Colors.green),
                      ListTile(
                        leading: Icon(Icons.pin_drop, color: Colors.grey),
                        title: Text('Jl. BKM Barat No.15, Sukapada, Kec. Cibeunying Kidul, Kota Bandung, Jawa Barat ', style: Theme.of(context).textTheme.subtitle),
                      ),
                      Divider(color: Colors.green),
                      ListTile(
                        leading: Icon(Icons.voicemail, color: Colors.grey),
                        title: Text('089666528074', style: Theme.of(context).textTheme.subtitle),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: Colors.green,
        onPressed: (){
          Navigator.of(context).pushNamed(ProfileEdit.routeName);
        },
      ),
    );
  }

  Widget _changePasswordModal(BuildContext context){
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeIn.transform(a2.value) - 0.2;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 20, 1.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)
                ),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                  children: <Widget>[
                    TextFormField(
                        // autofocus: true,
                        style: new TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: new InputDecoration(
                            labelText: 'Current Password', 
                            hintText: 'current password',
                            labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                            errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        errorStyle: TextStyle(color: Colors.orange),
                        ),
                        validator: (val){},
                        onSaved: (val){},
                      ),
                      TextFormField(
                        // autofocus: true,
                        style: new TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: new InputDecoration(
                            labelText: 'New Password', 
                            hintText: 'new password',
                            labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                            errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        errorStyle: TextStyle(color: Colors.orange),
                        ),
                        validator: (val){},
                        onSaved: (val){},
                      ),
                      TextFormField(
                        // autofocus: true,
                        style: new TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: new InputDecoration(
                            labelText: 'Confirm Password', 
                            hintText: 'confirm password',
                            labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                            errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        errorStyle: TextStyle(color: Colors.orange),
                        ),
                        validator: (val){},
                        onSaved: (val){},
                      ),
                    
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new FlatButton(
                      child: const Text('SAVE', style: TextStyle(color: Colors.green)),
                      onPressed: () {
                          Navigator.pop(context);
                          CustomNotif.alertDialogWithIcon(context, Icons.check_circle_outline, 'Success', 'change password success', false);
                        
                      })
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
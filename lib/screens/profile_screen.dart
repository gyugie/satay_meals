import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class UserProfile extends StatelessWidget {
  static const routeName = '/user-profile';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
      body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: deviceSize.width,
                height: deviceSize.height * 0.25,
                // height: 210.0,
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit, color: Colors.white),
          backgroundColor: Colors.green,
          onPressed: (){
          },

        ),
    );
  }
}
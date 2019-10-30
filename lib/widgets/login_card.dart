import 'package:flutter/material.dart';

enum AuthMode {Signup, Login}

class LoginCard extends StatefulWidget {
    const LoginCard({
    Key key,
  }) : super(key: key);

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  AuthMode _authMode                    = AuthMode.Login;
  final GlobalKey<FormState> _formKey   = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      decoration: new BoxDecoration(
        color: Colors.grey.withOpacity(0.6),
          borderRadius: new BorderRadius.circular(12.0),
        ),
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child:  Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: new InputDecoration(
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.grey),   
                      ), 
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    focusColor: Colors.white,
                  ),
                  validator: null,
                  onSaved: null,
                ),

                SizedBox(height: 10),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: new InputDecoration(
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.grey),   
                      ), 
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                      ),
                    ),
                    focusColor: Colors.white,
                  ),
                  validator: null,
                  onSaved: null,
                ),

                SizedBox(height: 20),
                
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Colors.white,
                  child: Text("Login".toUpperCase(),
                      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  onPressed: () {},
                ),

                 SizedBox(height: 20),

                Text('____________    OR    ____________', style: TextStyle(fontSize: 16, color: Colors.white)),
                
                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                     RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      color: Colors.blue[900],
                      child: Text("Login With Facebook",
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
          
        ],
      )
      )
    );
  }
}

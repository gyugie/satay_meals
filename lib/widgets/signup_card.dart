import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formSignup = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.grey.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.0)
      ),
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Form(
          key: _formSignup,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                validator: null,
                onSaved: null,
              ),

              SizedBox(height:10),

              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'E-mail',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                ),
                validator: null,
                onSaved: null,
              ),

              SizedBox(height: 10),

              TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
                validator: null,
                onSaved: null,
              ),

              SizedBox(height: 10),

              TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
                validator: null,
                onSaved: null,
              ),

              SizedBox(height: 10),

              TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Phone number',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.phone_android,
                    color: Colors.white,
                  ),
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
                  child: Text("Register".toUpperCase(),
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
                      child: Text("Signup With Facebook",
                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      onPressed: () {},
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
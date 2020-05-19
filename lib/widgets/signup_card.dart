import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../widgets/custom_notification.dart';
import '../providers/http_exception.dart';
import '../providers/auth.dart';

class SignUp extends StatefulWidget {
  final Function switchScreen;
  SignUp({Key key, this.switchScreen}) : super (key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formSignup  = GlobalKey();
  final _passwordController               = TextEditingController();
  final FirebaseAuth _auth                = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn              = GoogleSignIn(
                                              scopes: <String>[
                                                'email',
                                                'https://www.googleapis.com/auth/contacts.readonly',
                                              ],
                                            );
   Map<String, String> _newUser           = {
                                              'username': '',
                                              'email':'',
                                              'password':'',
                                              'phone':'',
                                              'google':''
                                            };
  bool _isLoading                         = false;
  bool _isGoogleSignUp                    = false;
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );

    
 
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode}, response: ${response.body}"
            "response. Check logs for details.";
      });

      return CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Authentication Failed ${response.statusCode}', '${response.body}', true);
    } else {
      setState(() {
        _newUser['google']      = _currentUser.id.toString();
        _newUser['username']    = _currentUser.displayName;
        _newUser['email']       = _currentUser.email;
        _newUser['password']    = '';
        _isGoogleSignUp         = true;
      });
       
      return _submitPayload();
    }

   
  }


  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Authentication Failed', error.toString(), true);
    }
  }


 Future<void> _submitSignup() async {
   if(!_formSignup.currentState.validate()){
     return;
   }

   _formSignup.currentState.save();
   setState(() {
     _isLoading = true;
   });

   _submitPayload();

 }

 Future<void> _submitPayload() async {

   try{
      await Provider.of<Auth>(context, listen: false).signUp(_newUser['username'], _newUser['email'], _newUser['password'], _newUser['phone'], _newUser['google']);
            CustomNotif.alertDialogWithIcon(context, Icons.check_circle_outline, 'Register success...', 'You have account for login now', false);
     
   
      widget.switchScreen(0);
   } on HttpException catch (err) {
        CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Authentication Failed', err.toString(), true);
   } catch (err){
        CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
   }
    await _googleSignIn.disconnect();
    setState(() {
     _isLoading = false;
     _isGoogleSignUp= false;
   });
 }


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
                    borderSide: BorderSide(color: Colors.orange[700])
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorStyle: TextStyle(color: Colors.orange),
                  hintText: "Username",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                validator: (value){
                  if(value.isEmpty || value == ''){
                    return "Username is required...!";
                  }
                },
                onSaved: (value){
                  _newUser['username'] = value;
                },
              ),

              SizedBox(height:10),

              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange[700])
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                   errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorStyle: TextStyle(color: Colors.orange),
                  hintText: 'E-mail',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                ),
                validator: (value){
                  if(value.isEmpty || !value.contains('@')){
                    return 'Invalid email';
                  }
                },
                onSaved: (value){
                  _newUser['email'] = value;
                },
              ),

              SizedBox(height: 10),

              TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange[700])
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                   errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorStyle: TextStyle(color: Colors.orange),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
                validator: (value){
                  if(value.isEmpty || value.length < 6){
                    return 'Password is too short';
                  }
                },
                onSaved: (value){
                  _newUser['password'] = value;
                },
              ),

              SizedBox(height: 10),

              TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange[700])
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                   errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorStyle: TextStyle(color: Colors.orange),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
                controller: _passwordController,
                validator: (value){
                  if(value != _passwordController.text){
                    return "Password do not match";
                  } else if (value.isEmpty){
                    return 'Password required!';
                  }
                },
              ),

              SizedBox(height: 10),

              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange[700])
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                   errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  errorStyle: TextStyle(color: Colors.orange),
                  hintText: 'Phone number',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.phone_android,
                    color: Colors.white,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value.isEmpty){
                    return 'Phone number is required';
                  }
                },
                onSaved: (value){
                  _newUser['phone'] = value;
                },
              ),

              SizedBox(height: 20),
              _isLoading ?
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[700]))
              :
              RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                color: Colors.orange[700],
                child: Text("Register".toUpperCase(),
                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                onPressed: _submitSignup,
              ),

              SizedBox(height: 20),
              
              Text('Or SignUp With', style: TextStyle(fontSize: 16, color: Colors.white)),
              
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _isGoogleSignUp
                  ?
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[700]))
                  :
                  _signUpGoogle(),
                  SizedBox(height: 20),
                  _logout(),
                ],
              ),

              SizedBox(height: 20),

                

            ],
          ),
        ),
      ),
    );
  }

  Widget _signUpGoogle() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _handleSignIn();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.orange[700]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            Image(image: AssetImage("assets/images/google_logo.png"), height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Google',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _logout() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        CustomNotif.alertDialogWithIcon(context, Icons.info_outline, 'Coming Soon!', 'for now not available', true);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.orange[700]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            Image(image: AssetImage("assets/images/fb-logo.png"), height: 30.0),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                'Facebook',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

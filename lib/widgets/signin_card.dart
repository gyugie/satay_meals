import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../widgets/custom_notification.dart';
import '../providers/http_exception.dart';
import '../widgets/verification_card.dart';
import '../providers/auth.dart';


class SignInCard extends StatefulWidget {
    const SignInCard({
    Key key,
  }) : super(key: key);

  @override
  _SignInCardState createState() => _SignInCardState();
}

class _SignInCardState extends State<SignInCard> {
  final GlobalKey<FormState> _formSignin  = GlobalKey();
  final FirebaseAuth _auth                = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn         = GoogleSignIn();
  GoogleSignIn _googleSignIn              = GoogleSignIn(
                                              scopes: <String>[
                                                'email',
                                                'https://www.googleapis.com/auth/contacts.readonly',
                                              ],
                                            );

  GoogleSignInAccount _currentUser;
  String _contactText;
  var _isLoading                          = false;
  var _isGoogleSignin                     = false;
  var _freshLoad                          = true;       
  Map<String, String> _authData = {
    'usernmae':'',
    'password':'',
    'uid'     : ''
  };

  String googleUid;
  String googleName;
  String googleEmail;
  String googleImageUrl;

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
        _authData['uid']      = _currentUser.id.toString();
        _authData['username']    = _currentUser.displayName;
        _authData['email']       = _currentUser.email;
        _authData['password']    = '';
        _isGoogleSignin          = true;
      });

      return _submitLogin(true);
    }

   
  }


  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Authentication Failed', error.toString(), true);
    }
  }

  Future<void> _submitLogin(bool isGoogleSignIn) async {
    if(!isGoogleSignIn){
      if(!_formSignin.currentState.validate()){
        return;
      }

      _formSignin.currentState.save();
      
        setState(() {
          _isLoading = true;
        });
    }

    try{
      await Provider.of<Auth>(context, listen: false).login(_authData['username'], _authData['password'], _authData['uid'], isGoogleSignIn);

    } on HttpException catch (err){
      if(err.toString().contains('Account is not active')){
         CustomNotif.alertDialogUserIsNotActive(context, Icons.error_outline, 'User Is Not Active', err.toString(), true);
      } else {
         CustomNotif.alertDialogUserIsNotActive(context, Icons.error_outline, 'Authenticated failed!', err.toString(), false);
         await Provider.of<Auth>(context).signOutGoogle();
      }
    } catch (err) {
        CustomNotif.alertDialogUserIsNotActive(context, Icons.error_outline, 'Something is wrong!', err.toString(), false);
        await Provider.of<Auth>(context).signOutGoogle();
    }

     setState(() {
      _isLoading = false;
      _isGoogleSignin = false;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
      decoration: new BoxDecoration(
        color: Colors.grey.withOpacity(0.6),
          borderRadius: new BorderRadius.circular(12.0),
        ),
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child:  Column(
        children: <Widget>[
          Form(
            key: _formSignin,
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: new InputDecoration(
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.green),   
                      ), 
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    errorStyle: TextStyle(color: Colors.orange),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    focusColor: Colors.white,
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return "Username is required";
                    }
                  },
                  onSaved: (value){
                    _authData['username'] = value;
                  },
                ),

                SizedBox(height: 10),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: new InputDecoration(
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.green),   
                      ), 
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    errorStyle: TextStyle(color: Colors.orange),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    focusColor: Colors.white,
                  ),
                  validator: (value){
                    if(value.isEmpty ){
                      return 'Password is required';
                    }
                    if(value.length < 5){
                      return 'Password is too short';
                    }
                  },
                  onSaved: (value){
                    _authData['password'] = value;
                  },
                ),

                SizedBox(height: 20),
                _isLoading ?
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green))
                :
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Colors.green,
                  child: Text("Login".toUpperCase(),
                      style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  onPressed: (){
                    _submitLogin(false);
                  },
                ),

                SizedBox(height: 20),

                Text('Or SignIn With', style: TextStyle(fontSize: 16, color: Colors.white)),
                
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _isLoading
                    ?
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green))
                    :
                    _googleButton(),

                    SizedBox(height: 20),
                    
                    _buttonFacebook()
                  ],
                ),

                SizedBox(height: 50),
                
                Text('Satay warrior v1.0', style: TextStyle(fontSize: 16, color: Colors.white)),

              ],
            ),
          ),
          ],
        )
      )
    );
  }

  Widget _googleButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: _handleSignIn,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.green),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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

  Widget _buttonFacebook() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        CustomNotif.alertDialogWithIcon(context, Icons.info_outline, 'Coming Soon!', 'for now not available', true);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.green),
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

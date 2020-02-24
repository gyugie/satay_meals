import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final GoogleSignIn googleSignIn         = GoogleSignIn();
  var _isLoading                          = false;
  bool _isGoogleSignUp                    = false;
   Map<String, String> _newUser          = {
                                              'username': '',
                                              'email':'',
                                              'password':'',
                                              'phone':'',
                                              'google':''
                                            };
  String googleUid;
  String googleName;
  String googleEmail;
  String googleImageUrl;

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
     print(err);
        CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
   }

    setState(() {
     _isLoading = false;
     _isGoogleSignUp= false;
   });
 }

 Future<String> signUpWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount               = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential                             = GoogleAuthProvider.getCredential(
                                                                  accessToken: googleSignInAuthentication.accessToken,
                                                                  idToken: googleSignInAuthentication.idToken,
                                                                );

    final FirebaseUser authResult = await _auth.signInWithCredential(credential);

    assert(authResult.email != null);
    assert(authResult.displayName != null);
    assert(authResult.photoUrl != null);
    assert(!authResult.isAnonymous);
    assert(await authResult.getIdToken() != null);
  
    setState(() {
      _newUser['google']      = authResult.uid;
      _newUser['username']    = authResult.displayName;
      _newUser['email']       = authResult.email;
      _newUser['password']    = '';
      _isGoogleSignUp         = true;
    });

    if(!_isGoogleSignUp){
      _submitPayload();
    }

   
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
                    borderSide: BorderSide(color: Colors.green)
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
                    borderSide: BorderSide(color: Colors.green)
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
                    borderSide: BorderSide(color: Colors.green)
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
                    borderSide: BorderSide(color: Colors.green)
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
                    borderSide: BorderSide(color: Colors.green)
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
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green))
              :
              RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                color: Colors.green,
                child: Text("Register".toUpperCase(),
                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                onPressed: _submitSignup,
              ),

                SizedBox(height: 20),
                
                _isGoogleSignUp
                 ?
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green))
                :
                _signUpGoogle()

                // Text('____________    OR    ____________', style: TextStyle(fontSize: 16, color: Colors.white)),
                
                // SizedBox(height: 30),

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
        signUpWithGoogle().whenComplete(() {
           
           _submitPayload();
        });
      },
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
                'Sign in with Google',
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

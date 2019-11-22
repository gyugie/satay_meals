import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_notification.dart';
import '../providers/http_exception.dart';
import '../providers/auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formSignup  = GlobalKey();
  final _passwordController               = TextEditingController();
  var _isLoading                          = false;
   Map<String, String> _newUser          = {
                                              'username': '',
                                              'email':'',
                                              'password':'',
                                              'phone':''
                                            };

 Future<void> _submitSignup() async {
   if(!_formSignup.currentState.validate()){
     return;
   }

   _formSignup.currentState.save();
   setState(() {
     _isLoading = true;
   });

   try{
      await Provider.of<Auth>(context, listen: false).signUp(_newUser['username'], _newUser['email'], _newUser['password'], int.parse(_newUser['phone']));
        CustomNotif.alertDialogWithIcon(context, Icons.check_circle_outline, 'Register success...', 'You have account for login now', false);
   } on HttpException catch (err) {
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Authentication Failed', err.toString(), true);
   } catch (err){
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
   }

   setState(() {
     _isLoading = false;
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
                    borderSide: BorderSide(color: Colors.grey)
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
                    borderSide: BorderSide(color: Colors.grey)
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
                    borderSide: BorderSide(color: Colors.grey)
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
                    borderSide: BorderSide(color: Colors.grey)
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
                    borderSide: BorderSide(color: Colors.grey)
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
              CircularProgressIndicator() :
              RaisedButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                color: Colors.white,
                child: Text("Register".toUpperCase(),
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                onPressed: _submitSignup,
              ),

                SizedBox(height: 20),

                // Text('____________    OR    ____________', style: TextStyle(fontSize: 16, color: Colors.white)),
                
                // SizedBox(height: 30),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: <Widget>[
                //      RaisedButton(
                //       shape: new RoundedRectangleBorder(
                //         borderRadius: new BorderRadius.circular(18.0),
                //       ),
                //       color: Colors.blue[900],
                //       child: Text("Signup With Facebook",
                //           style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                //         ),
                //       onPressed: () {},
                //     ),
                //   ],
                // )
            ],
          ),
        ),
      ),
    );
  }
}
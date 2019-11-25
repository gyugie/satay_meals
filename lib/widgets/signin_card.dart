import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final GlobalKey<FormState> _formSignin   = GlobalKey();
  var _isLoading                = false;
  Map<String, String> _authData = {
    'usernmae':'',
    'password':''
  };

  Future<void> _submitLogin() async {
    if(!_formSignin.currentState.validate()){
      return;
    }
    _formSignin.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try{
      await Provider.of<Auth>(context, listen: false).login(_authData['username'], _authData['password']);

    } on HttpException catch (err){
      if(err.toString().contains('Account is not active')){
         CustomNotif.alertDialogUserIsNotActive(context, Icons.error_outline, 'User Is Not Active', err.toString(), true);
      } else {
         CustomNotif.alertDialogUserIsNotActive(context, Icons.error_outline, 'Authenticated failed!', err.toString(), false);
      }
    } catch (err) {
        CustomNotif.alertDialogUserIsNotActive(context, Icons.error_outline, 'Something is wrong!', err.toString(), false);
    }

     setState(() {
      _isLoading = false;
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
                      borderSide: BorderSide(color: Colors.grey),   
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
                      borderSide: BorderSide(color: Colors.grey),   
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
                    if(value.isEmpty && value.length < 5){
                      return 'Password is too short';
                    }
                  },
                  onSaved: (value){
                    _authData['password'] = value;
                  },
                ),

                SizedBox(height: 20),
                _isLoading ?
                CircularProgressIndicator()
                :
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Colors.green,
                  child: Text("Login".toUpperCase(),
                      style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  onPressed: _submitLogin,
                ),

                SizedBox(height: 20),
                Text('Satay warrior v1.0', style: TextStyle(fontSize: 16, color: Colors.white)),
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
                //       child: Text("Login With Facebook",
                //           style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                //         ),
                //       onPressed: () {},
                //     ),
                //   ],
                // )
              ],
            ),
          ),
          
        ],
      )
      )
    );
  }
}

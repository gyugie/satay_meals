import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satay_meals/widgets/custom_notification.dart';
import '../providers/http_exception.dart';
import '../providers/auth.dart';


class VerificationCard extends StatefulWidget {
  @override
  _VerificationCardState createState() => _VerificationCardState();
}

class _VerificationCardState extends State<VerificationCard> {
  var _controllerVerification               = TextEditingController();
  final GlobalKey<FormState> _formVerified  = GlobalKey();
  var _isLoding                             = false; 


  _showAlertDialog(String title, String message, bool isVerification){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Close', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context),
          ),
          isVerification 
          ?
          FlatButton(
            child: Text('OK!', style: TextStyle(color: Colors.red)),
            onPressed: (){
              Navigator.pop(context);
               Navigator.pop(context, true);
               
            },
          )
          :
          null
          
        ],
      )
    );
  }

  void _submitActivation() async {
    final validation = _formVerified.currentState.validate();

    if(!validation){
      return;
    }

    _formVerified.currentState.save();
    setState(() {
      _isLoding = true;
    });
  
    try{
      await Provider.of<Auth>(context, listen: false).verificationCode(_controllerVerification.text);
      CustomNotif.alertVerification(context, Icons.check_circle_outline, 'Verification Success', 'Congratulation verification is success, you have login now', true);
    } on HttpException catch (err){
      CustomNotif.alertVerification(context, Icons.error_outline, 'Verification Failed!', err.toString(), false);
    } catch (err){
     CustomNotif.alertVerification(context, Icons.error_outline, 'An error occured!', err.toString(), false);
    }

    setState(() {
      _isLoding = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Account Setup', style: TextStyle(
            color: Colors.green[200], 
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Enter your verification code', style: 
                  TextStyle(
                    color: Colors.green[200], 
                    fontSize: 24, 
                    fontWeight: FontWeight.bold)
                  ),
                SizedBox(height: 50),
                Form(
                  key: _formVerified,
                  child: TextFormField(
                    controller: _controllerVerification,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
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
                      hintText: 'Enter code here',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 24 ),
                      filled: true,
                      focusColor: Colors.white,
                      suffixIcon: IconButton(
                        onPressed: () => _controllerVerification.clear(),
                        icon: Icon(Icons.highlight_off, color: Colors.grey,),
                      ),
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return "Activation code is required";
                      }
                    },
                    onSaved: (value){
                     
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text('Please enter the verification code you recieve \n by email', style: TextStyle(
                  color: Colors.green[200], 
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _isLoding 
                ?
                CircularProgressIndicator()
                :
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FlatButton(
                    color: Colors.green[300],
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: _submitActivation,
                    child: Text(
                      "Verification",
                      style: TextStyle(color: Colors.white,fontSize: 20.0),
                    ),
                  )
                )

            ],
          ),
        )
      )
    );
  }
}
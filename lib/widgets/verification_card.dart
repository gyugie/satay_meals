import 'package:flutter/material.dart';

class VerifivationCard extends StatelessWidget {
  static const routeName = '/verification';
  var _controller = TextEditingController();
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
        automaticallyImplyLeading: false,
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
                TextFormField(
                    controller: _controller,
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
                        onPressed: () => _controller.clear(),
                        icon: Icon(Icons.highlight_off, color: Colors.grey,),
                      ),
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return "Username is required";
                      }
                    },
                    onSaved: (value){
                    },
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: FlatButton(
                      color: Colors.green[300],
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        /*...*/
                      },
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
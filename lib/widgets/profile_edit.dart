import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class ProfileEdit extends StatefulWidget {
  static const routeName = '/profile-edit';
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
     final deviceSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: Theme.of(context).textTheme.title),
        elevation: 0.0,
        backgroundColor: Colors.black.withOpacity(0.03),
        iconTheme: new IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: orientation == Orientation.portrait ? deviceSize.height * 0.25 : deviceSize.height * 0.6,
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
                FractionalTranslation(
                  translation:orientation == Orientation.portrait ?  Offset(-0.23, -1.3) : Offset(-0.3, -2),
                  child: Align(
                    child: GestureDetector(
                      onTap: (){
                        print('like');
                      },
                      child: CircleAvatar(
                      foregroundColor: Colors.black,
                      backgroundColor:  Colors.white,
                      radius: 20.0,
                      child: Icon(Icons.camera_alt,size: 20),
                    ),
                  ),
                  alignment: FractionalOffset(0.90, 0.55),
                ),
              ),
              Form(
                key: null,
                child: Container(
                height: deviceSize.height * 0.52,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: deviceSize.width * 0.4,
                              child: TextFormField(
                                style: new TextStyle(color: Colors.white),
                                decoration: new InputDecoration(
                                  labelText: 'Frist Name', 
                                  labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                  ),
                                  enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Colors.green),   
                                  ),  
                                  errorStyle: TextStyle(color: Colors.orange),
                                ),
                                validator: (val){},
                                onSaved: (val){},
                              ),
                            ),
                            Container(
                              width: deviceSize.width * 0.4,
                              child: TextFormField(
                                style: new TextStyle(color: Colors.white),
                                decoration: new InputDecoration(
                                    labelText: 'Last Name', 
                                    labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                    errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                  ),
                                  enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Colors.green),   
                                  ),  
                                  errorStyle: TextStyle(color: Colors.orange),
                                ),
                                validator: (val){},
                                onSaved: (val){},
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          style: new TextStyle(color: Colors.white),
                          decoration: new InputDecoration(
                            labelText: 'Phone Number', 
                            labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                            enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color: Colors.green),   
                            ),  
                            errorStyle: TextStyle(color: Colors.orange),
                          ),
                          validator: (val){},
                          onSaved: (val){},
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              width: deviceSize.width * 0.4,
                              child:Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.black,
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('City', 
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.green,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },

                                  items: <String>['One', 'Two', 'Free', 'Four']
                                    .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                    .toList(),
                                ),
                              )
                            ),
                            Container(
                              width: deviceSize.width * 0.4,
                              padding: EdgeInsets.only(top: 10),
                              child:Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.black,
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text('City', 
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.green,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },

                                  items: <String>['One', 'Two', 'Free', 'Four']
                                    .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                    .toList(),
                                ),
                              )
                            )
                          ],
                        ),
                        Container(
                          child: TextFormField(
                            initialValue:'',
                            decoration: new InputDecoration(
                                labelText: 'Address', 
                                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                 errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              enabledBorder: UnderlineInputBorder(      
                                borderSide: BorderSide(color: Colors.green),   
                              ),  
                              errorStyle: TextStyle(color: Colors.orange),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            validator: (value){ 
                              if(value.isEmpty){
                                return 'Description is required!';
                              }

                              if(value.length < 10){
                                return 'Should be at least a long text';
                              }

                              return null;
                            },
                            onSaved: (value){
                              
                            },
                          ),
                        ),
                        TextFormField(
                          style: new TextStyle(color: Colors.white),
                          decoration: new InputDecoration(
                            labelText: 'Postal Code', 
                            labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                             errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                            enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color: Colors.green),   
                            ),  
                            errorStyle: TextStyle(color: Colors.orange),
                          ),
                          validator: (val){},
                          onSaved: (val){},
                        ),

                        
                      ],
                    ),
                  )
                )
              )
            ],
          ),
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


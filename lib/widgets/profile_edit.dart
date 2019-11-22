import 'dart:convert';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/http_exception.dart';
import '../widgets/custom_notification.dart';
import '../widgets/drawer.dart';
import '../providers/user.dart';

class ProfileEdit extends StatefulWidget {
  static const routeName = '/profile-edit';
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<FormState> _formEditUser     = GlobalKey(); 
  var _isInit                 = true;
  var _isLoading              = false;
  var _cityLoading            = false;
  var _tempState;
  var _tempCity;
  var _selectCityName;
  var _selectCityId;
  var _selectStateName;
  var _selectStateId;
  List<UserState> _listState  = [];
  List<UserCity> _listCity    = [];
  UserCity _selectedCity;
  String _validationCity      = '';
  String _validationState     = '';
  Map<String, double> userLocation;
  UserState _selectedState;
  File file;
  String base64Image;
  String fileName;           
  String path;
  Dio dio = new Dio();
  var _currentProfile         = {
    'id':'',
    'username':'',
    'firstName':'',
    'lastName':'',
    'email':'',
    'phone':'',
    'address':'',
    'image':'',
    'latitude':'',
    'longitude':'',
    'postalCode':'',
    'stateId':'',
    'stateName':'',
    'cityId':'',
    'cityName':'',
  };


  Future<void> _loadDataState(){
     
      Future.wait([
        Provider.of<User>(context).fetchListState(),
        Provider.of<User>(context).fetchListCity(_selectStateId != '' ? _selectStateId.toString() : '3'),
        Provider.of<User>(context).fetchUserProfile(),
        Provider.of<User>(context).getLocation()
      ]).then( (List result){
        _listState  = [];
        _listCity   = [];
        _tempState  = json.decode(result[0]);
        _tempCity   = json.decode(result[1]);
        setState(() {
          userLocation= result[3];
        });

        for(int i = 0; i < _tempState['data'].length; i++){
          _listState.add(UserState(
            stateId: int.parse(_tempState['data'][i]['state_id']),
            stateName: _tempState['data'][i]['name']
          ));
        }

        for(int i = 0; i < _tempCity['data'].length; i++){
          _listCity.add(UserCity(
            cityId: int.parse(_tempCity['data'][i]['city_id']),
            cityName: _tempCity['data'][i]['name']
          ));
        }

        setState(() {
          _isLoading = false;
        });
      }).catchError( (err){
        CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
      });

      

    
  }


  _onChangesState(UserState value){
     
    setState(() {
      _selectedState    = value;
      _cityLoading      = true;
    });

    Provider.of<User>(context).fetchListCity(value.stateId.toString())
    .then((Object val){
     
      _tempCity = json.decode(val);
      _listCity = [];
      for(int i = 0; i < _tempCity['data'].length; i++){
        _listCity.add(UserCity(
          cityId: int.parse(_tempCity['data'][i]['city_id']),
          cityName: _tempCity['data'][i]['name']
        ));
      }

      setState(() {
        _cityLoading = false;
      });
    }).catchError( (err){
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
    });
   
  }


  _loadCurrentProfile(){
      var _editUser               = Provider.of<User>(context).userProfile;
    setState(() {
      var _user                   = _editUser['userProfile'];
          _currentProfile         = {
            'id'          :_user == null ? '-' : (_user.id == '')           ? '' : _user.id,
            'username'    :_user == null ? '-' : (_user.username == '')     ? '' : _user.username,
            'firstName'   :_user == null ? '-' : (_user.firstName == '')    ? '' : _user.firstName,
            'lastName'    :_user == null ? '-' : (_user.lastName == '')     ? '' : _user.lastName,
            'email'       :_user == null ? '-' : (_user.email == '')        ? '' : _user.email,
            'phone'       :_user == null ? '' : (_user.phone == '')        ? '' : _user.phone.toString(),
            'address'     :_user == null ? '-' : (_user.address == '')      ? '' : _user.address,
            'image'       :_user == null ? '-' : (_user.image == '')        ? '' : _user.image,
            'latitude'    :_user == null ? '-' : (_user.latitude == '')     ? '' : _user.latitude,
            'longitude'   :_user == null ? '-' : (_user.longitude == '')    ? '' : _user.longitude,
            'postalCode'  :_user == null ? '-' : (_user.postalCode == null) ? '' : _user.postalCode,
          };

          _selectStateName = _user == null ? '' : (_user.stateName == null)  ? '' : _user.stateName;
          _selectStateId   = _user == null ? '' : (_user.stateId == null)   ? '' : _user.stateId; 
          _selectCityName  = _user == null ? '' : (_user.cityName == null)   ? '' : _user.cityName;
          _selectCityId    = _user == null ? '' : (_user.cityId == null)   ? '' : _user.cityId;
    });

   
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      file = selected;
    });
  }

  void _updateUser() async {
    var validate = _formEditUser.currentState.validate();

    if(_selectStateName == ''){
      setState(() {
        _validationState = 'please select your state';
      });
      validate = false;
    } else if(_selectCityName == ''){
      setState(() {
        _validationCity   = 'please select your city';
      });
      validate = false;
    }

      if(file != null){
        fileName     = file.path.split("/").last;
        path         = file.path;
      }
    
    if(!validate){
      return;
    }

    _formEditUser.currentState.save();
    setState(() {
      _isLoading = true;
    });
              
    try{
       
      await Provider.of<User>(context).updateUserProfile(fileName, path, _currentProfile['username'], _currentProfile['firstName'], _currentProfile['lastName'], _currentProfile['address'],  userLocation['latitude'].toString(), userLocation['longitude'].toString(), _currentProfile['postalCode'], _currentProfile['cityId'], _currentProfile['stateId']);
      Provider.of<User>(context).fetchUserProfile().then((val){
        CustomNotif.alertDialogWithIcon(context, Icons.check_circle_outline, 'Edit Profile Success', 'your profile is updated', false, true);
      });
     } on HttpException catch (err) {
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Edit Profile failed', err.toString(), true);
   } catch (err){
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
   }

     setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies()  {
    if(_isInit){
      _isLoading = true;
      _loadDataState();
      _loadCurrentProfile();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    print(file);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: Theme.of(context).textTheme.title),
        elevation: 0.0,
        backgroundColor: Colors.black.withOpacity(0.03),
        iconTheme: new IconThemeData(color: Colors.green),
      ),
      body: 
      _isLoading
      ?
      Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
      )
      :
      SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: orientation == Orientation.portrait ? deviceSize.height * 0.30 : deviceSize.height * 0.6,
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
                          image: ( file != null ) ? FileImage(file) : (_currentProfile['image'] == '') ? AssetImage('assets/images/user-unknown.jpeg') : NetworkImage(_currentProfile['image'])
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(160)),
                        color: Colors.grey,
                      ),
                    ),
                  )
                ),
                FractionalTranslation(
                  translation:orientation == Orientation.portrait ?  Offset(-0.23, -1.3) : Offset(-0.3, -2),
                  child: Align(
                    child: GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
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
                key: _formEditUser,
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
                                  labelText: 'Frist Name *', 
                                  labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                  ),
                                  enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Colors.green),   
                                  ),  
                                  errorStyle: TextStyle(color: Colors.orange),
                                ),
                                initialValue: _currentProfile['firstName'],
                                validator: (val){
                                  if(val.isEmpty){
                                    return 'please fill your first name';
                                  }
                                },
                                onSaved: (val){
                                   _currentProfile         = {
                                        'id'          : _currentProfile['id'], 
                                        'username'    : _currentProfile['username'], 
                                        'firstName'   : val, 
                                        'lastName'    : _currentProfile['lastName'], 
                                        'email'       : _currentProfile['email'], 
                                        'phone'       : _currentProfile['phone'], 
                                        'address'     : _currentProfile['address'], 
                                        'image'       : _currentProfile['image'], 
                                        'latitude'    : _currentProfile['latitude'],
                                        'longitude'   : _currentProfile['longitude'],
                                        'postalCode'  : _currentProfile['postalCode'],
                                        'stateId'     : _selectStateId.toString(),
                                        'stateName'   : _selectStateName,
                                        'cityId'      : _selectCityId.toString(), 
                                        'cityName'    : _selectCityName,
                                      }; 
                                },
                              ),
                            ),
                            Container(
                              width: deviceSize.width * 0.4,
                              child: TextFormField(
                                style: new TextStyle(color: Colors.white),
                                decoration: new InputDecoration(
                                    labelText: 'Last Name *', 
                                    labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                    errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orange),
                                  ),
                                  enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Colors.green),   
                                  ),  
                                  errorStyle: TextStyle(color: Colors.orange),
                                ),
                                initialValue: _currentProfile['lastName'],
                                validator: (val){
                                  if(val.isEmpty){
                                    return 'please fill your last name';
                                  }
                                },
                                onSaved: (val){
                                   _currentProfile         = {
                                        'id'          : _currentProfile['id'], 
                                        'username'    : _currentProfile['username'], 
                                        'firstName'   : _currentProfile['firstName'], 
                                        'lastName'    : val, 
                                        'email'       : _currentProfile['email'], 
                                        'phone'       : _currentProfile['phone'], 
                                        'address'     : _currentProfile['address'], 
                                        'image'       : _currentProfile['image'], 
                                        'latitude'    : _currentProfile['latitude'],
                                        'longitude'   : _currentProfile['longitude'],
                                        'postalCode'  : _currentProfile['postalCode'],
                                        'stateId'     : _selectStateId.toString(),
                                        'stateName'   : _selectStateName,
                                        'cityId'      : _selectCityId.toString(), 
                                        'cityName'    : _selectCityName,
                                      }; 
                                },
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          style: new TextStyle(color: Colors.white),
                          decoration: new InputDecoration(
                            labelText: 'Phone Number *', 
                            labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                            enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color: Colors.green),   
                            ),  
                            errorStyle: TextStyle(color: Colors.orange),
                          ),
                          initialValue: _currentProfile['phone'],
                          validator: (val){
                            if(val.isEmpty){
                              return 'please fill your phone';
                            }
                          },
                          onSaved: (val){
                             _currentProfile         = {
                                'id'          : _currentProfile['id'], 
                                'username'    : _currentProfile['username'], 
                                'firstName'   : _currentProfile['firstName'], 
                                'lastName'    : _currentProfile['lastName'], 
                                'email'       : _currentProfile['email'], 
                                'phone'       : val, 
                                'address'     : _currentProfile['address'], 
                                'facebookId'  : _currentProfile['facebookId'], 
                                'googleId'    : _currentProfile['googleId'], 
                                'joinDate'    : _currentProfile['joinDate'], 
                                'image'       : _currentProfile['image'], 
                                'latitude'    : _currentProfile['latitude'],
                                'longitude'   : _currentProfile['longitude'],
                                'postalCode'  : _currentProfile['postalCode'],
                                'stateId'     : _currentProfile['stateId'],
                                'stateName'   : _currentProfile['stateName'],
                                'cityId'      : _currentProfile['cityId'], 
                                'cityName'    : _currentProfile['cityName'],
                              }; 
                          },
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: deviceSize.width * 0.4,
                              padding: EdgeInsets.only(top: 10),
                              child:Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.black,
                                ),
                                child: DropdownButton<UserState>(
                                  isExpanded: true,
                                  hint: Text("${_selectStateName != '' ?  _selectStateName :  'Select State *' }", style: TextStyle(color: Colors.white)),
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: _validationState == null ? Colors.orange : Colors.green,
                                  ),
                                  value: _selectedState,
                                  onChanged: (value) {
                                    _onChangesState(value);
                                    
                                    setState(() {
                                      _selectStateId    = value.stateId;
                                      _selectStateName  = value.stateName;
                                    });
                                     
                                    _currentProfile         = {
                                      'id'          : _currentProfile['id'], 
                                      'username'    : _currentProfile['username'], 
                                      'firstName'   : _currentProfile['firstName'], 
                                      'lastName'    : _currentProfile['lastName'], 
                                      'email'       : _currentProfile['email'], 
                                      'phone'       : _currentProfile['phone'], 
                                      'address'     : _currentProfile['address'], 
                                      'image'       : _currentProfile['image'], 
                                      'latitude'    : _currentProfile['latitude'],
                                      'longitude'   : _currentProfile['longitude'],
                                      'postalCode'  : _currentProfile['postalCode'],
                                      'stateId'     : _selectStateId.toString(),
                                      'stateName'   : _selectStateName,
                                      'cityId'      : _selectCityId.toString(), 
                                      'cityName'    : _selectCityName,
                                    }; 
                                  },
                                  
                                  items: _listState.map((UserState state) {
                                    return  DropdownMenuItem<UserState>(
                                      value: state,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(width: 10,),
                                          Text(
                                            state.stateName,
                                            style:  TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            ),
                            _cityLoading
                            ?
                            Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green))
                            )
                            :
                            Container(
                              width: deviceSize.width * 0.4,
                              padding: EdgeInsets.only(top: 10),
                              child:Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.black,
                                ),
                                child: DropdownButton<UserCity>(
                                  isExpanded: true,
                                  hint: Text('${_selectCityName != '' ?  _selectCityName :  'Select City *' }', 
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                  value: null,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  underline: Container(
                                    height: 1,
                                    color: _validationCity == null ? Colors.orange : Colors.green,
                                  ),
                                  onChanged: (UserCity value) {
                                    setState(() {
                                      _selectedCity   = value;
                                      _selectCityName = value.cityName;
                                      _selectCityId   = value.cityId;
                                    });

                                    _currentProfile         = {
                                        'id'          : _currentProfile['id'], 
                                        'username'    : _currentProfile['username'], 
                                        'firstName'   : _currentProfile['firstName'],
                                        'lastName'    : _currentProfile['lastName'], 
                                        'email'       : _currentProfile['email'], 
                                        'phone'       : _currentProfile['phone'], 
                                        'address'     : _currentProfile['address'], 
                                        'image'       : _currentProfile['image'], 
                                        'latitude'    : _currentProfile['latitude'],
                                        'longitude'   : _currentProfile['longitude'],
                                        'postalCode'  : _currentProfile['postalCode'],
                                        'stateId'     : _selectStateId.toString(),
                                        'stateName'   : _selectStateName,
                                        'cityId'      : _selectCityId.toString(), 
                                        'cityName'    : _selectCityName,
                                      }; 
                                            
                                  },
                                  items: _listCity.map((UserCity city) {
                                    return  DropdownMenuItem<UserCity>(
                                      value: city,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(width: 10),
                                          Text(
                                            city.cityName,
                                            style:  TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            )
                          ],
                        ),
                        if(_validationState != '' || _validationCity != '')
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            if(_validationState != '')
                            Container(
                              width: deviceSize.width * 0.4,
                              child: Text(_validationState, style: TextStyle(fontSize: 14, color: Colors.orange))
                            ),
                            if(_validationCity != '')
                            Container(
                              width: deviceSize.width * 0.4,
                              child: Text(_validationCity, style: TextStyle(fontSize: 14, color: Colors.orange))
                            )
                          ],
                        ),
                        Container(
                          child: TextFormField(
                            decoration: new InputDecoration(
                                labelText: 'Address *', 
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
                            initialValue: _currentProfile['address'],
                            validator: (value){ 
                              if(value.isEmpty){
                                return 'Description is required!';
                              }

                              if(value.length < 10){
                                return 'Should be at least a long text';
                              }

                              return null;
                            },
                            onSaved: (val){
                              _currentProfile         = {
                                  'id'          : _currentProfile['id'], 
                                  'username'    : _currentProfile['username'], 
                                  'firstName'   : _currentProfile['firstName'],
                                  'lastName'    : _currentProfile['lastName'], 
                                  'email'       : _currentProfile['email'], 
                                  'phone'       : _currentProfile['phone'], 
                                  'address'     : val, 
                                  'facebookId'  : _currentProfile['facebookId'], 
                                  'googleId'    : _currentProfile['googleId'], 
                                  'joinDate'    : _currentProfile['joinDate'], 
                                  'image'       : _currentProfile['image'], 
                                  'latitude'    : _currentProfile['latitude'],
                                  'longitude'   : _currentProfile['longitude'],
                                  'postalCode'  : _currentProfile['postalCode'],
                                  'stateId'     : _currentProfile['stateId'],
                                  'stateName'   : _currentProfile['stateName'],
                                  'cityId'      : _currentProfile['cityId'], 
                                  'cityName'    : _currentProfile['cityName'],
                                }; 
                            },
                          ),
                        ),
                        TextFormField(
                          style: new TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: 'Postal Code *', 
                            labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                             errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                            enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color: Colors.green),   
                            ),  
                            errorStyle: TextStyle(color: Colors.orange),
                          ),
                          initialValue: _currentProfile['postalCode'],
                          validator: (val){
                            if(val.isEmpty){
                              return 'please fill your postal code';
                            }
                          },
                          onSaved: (val){
                            _currentProfile         = {
                                'id'          : _currentProfile['id'], 
                                'username'    : _currentProfile['username'], 
                                'firstName'   : _currentProfile['firstName'],
                                'lastName'    : _currentProfile['lastName'], 
                                'email'       : _currentProfile['email'], 
                                'phone'       : _currentProfile['phone'], 
                                'address'     : _currentProfile['address'], 
                                'facebookId'  : _currentProfile['facebookId'], 
                                'googleId'    : _currentProfile['googleId'], 
                                'joinDate'    : _currentProfile['joinDate'], 
                                'image'       : _currentProfile['image'], 
                                'latitude'    : _currentProfile['latitude'],
                                'longitude'   : _currentProfile['longitude'],
                                'postalCode'  : val,
                                'stateId'     : _currentProfile['stateId'],
                                'stateName'   : _currentProfile['stateName'],
                                'cityId'      : _currentProfile['cityId'], 
                                'cityName'    : _currentProfile['cityName'],
                              }; 
                          },
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
        child: Icon(Icons.save, color: Colors.white),
        backgroundColor: Colors.green,
        onPressed: (){
          // _loadDataState();
          // _loadCurrentProfile();
          _updateUser();
        },
      ),
    );
  }
}


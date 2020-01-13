import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satay_meals/providers/http_exception.dart';
import '../widgets/custom_notification.dart';
import '../widgets/profile_edit.dart';
import '../widgets/drawer.dart';
import '../providers/user.dart';
import '../providers/auth.dart';

class UserProfile extends StatefulWidget {
  static const routeName = '/user-profile';
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formChangePassword  = GlobalKey();
  final _passwordController                       = TextEditingController();
  var _isInit = true;
  Map<String, String> _newPassword        = {
    'oldPassword': '',
    'newPassword': ''
  };
  AnimationController controller;
  Animation<double> animation;

  void initState(){
    super.initState();
    controller = AnimationController(
    duration: const Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInToLinear);

    controller.forward();
  }


  Future<void> _submitChangePassword() async {
    if(!_formChangePassword.currentState.validate()){
      return;
    }
   
    _formChangePassword.currentState.save();
    try{
      await Provider.of<Auth>(context).changePassword(_newPassword['oldPassword'], _newPassword['newPassword']);
       CustomNotif.alertDialogWithIcon(context, Icons.check_circle_outline, 'Change Password Success...', 'now you have new password', false, true);
   } on HttpException catch (err) {
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'Change Password failed', err.toString(), true);
   } catch (err){
      CustomNotif.alertDialogWithIcon(context, Icons.error_outline, 'An error occured!', err.toString(), true);
   }
  }

  @override
  void didChangeDependencies()async {
    if(_isInit){
      await Provider.of<User>(context).fetchUserProfile();
      
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize  = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    var _get          = Provider.of<User>(context, listen: false).userProfile;
    var _user         = _get['userProfile'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.title),
        elevation: 0.0,
        backgroundColor: Colors.black.withOpacity(0.03),
        iconTheme: new IconThemeData(color: Colors.green),
      ),
      drawer: Theme(
       data: Theme.of(context).copyWith(
         canvasColor: Colors.black.withOpacity(0.5)
       ),
       child: DrawerSide(),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: FadeTransition(
        opacity: animation,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
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
                          image:  _user.image == '' ? AssetImage('assets/images/user-unknown.jpeg') : NetworkImage(_user.image)
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(160)),
                        color: Colors.grey,
                      ),
                    ),
                  )
                ),
                Center(
                  child: Text('${_user == null ? '-' : (_user.firstName == '') ? 'not set' : _user.firstName +' '+ _user.lastName }', style: Theme.of(context).textTheme.title)
                ),
                SizedBox(height: 10),
                Center(
                  child: Text('${_user == null ? '-' : (_user.username == '') ? 'not set' : _user.username }', style: Theme.of(context).textTheme.subtitle)
                ),
                SizedBox(height: 20),
                Divider(color: Colors.green),
                Container(
                  height: deviceSize.height * 0.52,
                  child: SingleChildScrollView(
                    child: Column(
                    children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.email, color: Colors.grey),
                          title: Text('${_user == null ? '-' : (_user.email != '') ? _user.email : 'not set'  }', style: Theme.of(context).textTheme.subtitle),
                        ),
                        Divider(color: Colors.green),
                        ListTile(
                          leading: Icon(Icons.lock, color: Colors.grey),
                          title: Text('******', style: Theme.of(context).textTheme.subtitle),
                          trailing: GestureDetector(
                            child:  Icon(Icons.open_in_new),
                            onTap: (){
                              _changePasswordModal(context);
                            },
                          ),
                        ),
                        Divider(color: Colors.green),
                        ListTile(
                          leading: Icon(Icons.phone, color: Colors.grey),
                          title: Text('${_user == null ? '-' : (_user.phone != null) ? _user.phone.toString() : 'not set'  }', style: Theme.of(context).textTheme.subtitle),
                        ),
                        Divider(color: Colors.green),
                        ListTile(
                          leading: Icon(Icons.account_balance, color: Colors.grey),
                          title: Text('${_user == null ? '-' : (_user.stateName != null) ? _user.stateName : 'not set'  }', style: Theme.of(context).textTheme.subtitle),
                        ),
                        Divider(color: Colors.green),
                        ListTile(
                          leading: Icon(Icons.business, color: Colors.grey),
                          title: Text('${_user == null ? '-' : (_user.cityName != null) ? _user.cityName : 'not set'  }', style: Theme.of(context).textTheme.subtitle),
                        ),
                        Divider(color: Colors.green),
                        ListTile(
                          leading: Icon(Icons.pin_drop, color: Colors.grey),
                          title: Text('${_user == null ? '-' : (_user.address != '') ? _user.address : 'not set'  }', style: Theme.of(context).textTheme.subtitle),
                        ),
                        Divider(color: Colors.green),
                        ListTile(
                          leading: Icon(Icons.voicemail, color: Colors.grey),
                          title: Text('${_user == null ? '-' : (_user.postalCode != null) ? _user.postalCode : 'not set'  }', style: Theme.of(context).textTheme.subtitle),
                        ),
                        Divider(color: Colors.green),
                        ListTile(
                          leading: Icon(Icons.insert_invitation, color: Colors.grey),
                          title: Text('${_user == null ? '-' : (_user.joinDate != null) ? _user.joinDate : 'not set'  }', style: Theme.of(context).textTheme.subtitle),
                        ),
                        SizedBox(height: 33),
                      ],
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: Colors.green,
        onPressed: (){
          Navigator.of(context).pushNamed(ProfileEdit.routeName);
        },
      ),
    );
  }

  Widget _changePasswordModal(BuildContext context){
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeIn.transform(a2.value) - 0.2;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 20, 1.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)
                ),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Form(
                    key: _formChangePassword,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            // autofocus: true,
                            style: new TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: new InputDecoration(
                                labelText: 'Current Password', 
                                hintText: 'current password',
                                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            errorStyle: TextStyle(color: Colors.orange),
                            ),
                            validator: (val){
                               
                              if(val.isEmpty){
                                return 'Please fill old password';
                              }

                            },
                            onSaved: (val){
                              _newPassword['oldPassword'] = val;
                            },
                          ),
                          TextFormField(
                            // autofocus: true,
                            controller: _passwordController,
                            style: new TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: new InputDecoration(
                                labelText: 'New Password', 
                                hintText: 'new password',
                                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            errorStyle: TextStyle(color: Colors.orange),
                            ),
                            validator: (val){

                              if(val.isEmpty){
                                return 'Please fill old password';
                              } else if( val.length < 6 ){
                                return 'password is too shoort, min 6 character';
                              }

                            },
                            onSaved: (val){
                              _newPassword['newPassword'] = val;
                            },
                          ),
                          TextFormField(
                            // autofocus: true,
                            style: new TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: new InputDecoration(
                                labelText: 'Confirm Password', 
                                hintText: 'confirm password',
                                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                                errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            errorStyle: TextStyle(color: Colors.orange),
                            ),
                            validator: (val){
                              
                              if( _passwordController.text != val){
                                return 'Password not match';
                              }else if(val.isEmpty){
                                return 'Please confirm password';
                              }

                            },
                          ),
                        
                        ],
                      ),
                  )
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new FlatButton(
                      child: const Text('SAVE', style: TextStyle(color: Colors.green)),
                      onPressed: () {
                        _submitChangePassword();
                      
                      })
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
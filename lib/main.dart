import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import './screens/home_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black
        ),
        home: authData.isAuth ? HomeScreen() : FutureBuilder(
          future: authData.tryToAutoLogin(),
          builder: (ctx, authSnapshot) => authSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
        ),
        routes: {

        },
      ),
      )
    );
  }
}
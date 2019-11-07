import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './screens/payment_screen.dart';
import './screens/checkout_screen.dart';
import './screens/order_screen.dart';
import './providers/products.dart';
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
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, cachedProduct) => Products(
            auth.token,
            auth.role,
            auth.userId,
            cachedProduct == null ? [] : cachedProduct.products
          ), initialBuilder: (BuildContext context) {},
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
          brightness: Brightness.dark,
          accentColor: Colors.grey.withOpacity(0.3),
          textTheme: TextTheme(
            headline: TextStyle(
              fontFamily: 'Play',
              fontSize: 24,
              color: Colors.white,
            ),
            title: TextStyle(
              fontFamily: 'Play',
              fontSize: 20,
              color: Colors.white,
            ),
            subtitle: TextStyle(
              fontFamily: 'Play',
              fontSize: 16,
              color: Colors.grey,
            ),
            display1: TextStyle(
              fontFamily: 'Play',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white
            )
            
          )
        ),
        home: authData.isAuth ? HomeScreen() : FutureBuilder(
          future: authData.tryToAutoLogin(),
          builder: (ctx, authSnapshot) => authSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
        ),
        routes: {
          OrderScreen.routeName : (ctx) => OrderScreen(),
          CheckoutScreen.routeName : (ctx) => CheckoutScreen(),
          PaymentScreen.routeName : (ctx) => PaymentScreen()
        },
      ),
      )
    );
  }
}
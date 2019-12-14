import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './widgets/profile_edit.dart';
import './screens/profile_screen.dart';
import './screens/about_us_screen.dart';
import './screens/terms_and_condition_screen.dart';
import './screens/topup_pending.dart';
import './providers/topup.dart';
import './screens/topup_screen.dart';
import './screens/history_order_screen.dart';
import './providers/orders.dart';
import './providers/user.dart';
import './providers/cart_item.dart';
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
        ChangeNotifierProxyProvider<Auth, User>(
          builder: (ctx, auth, cachedUser) => User(
            auth.token,
            auth.userId,
            auth.role, 
            ), initialBuilder: (BuildContext context) { return; },
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, cachedProduct) => Products(
            auth.token,
            auth.role,
            auth.userId,
            cachedProduct == null ? [] : cachedProduct.products
          ), initialBuilder: (BuildContext context) {return;},
        ),
        ChangeNotifierProvider.value(
          value: CartItem(),
        ),
        ChangeNotifierProxyProvider<Auth, SatayTopup>(
          builder: (ctx, auth, cachedTopup) => SatayTopup(
            auth.userId,
            auth.token,
            auth.role,
          ), initialBuilder: (BuildContext context) { return;},
        ),
        ChangeNotifierProxyProvider<Auth, ItemOrders>(
          builder: (ctx, auth, chachedOrder) => ItemOrders(
            auth.token,
            auth.role,
            auth.userId,
          ), initialBuilder: (BuildContext context) { return;},
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) => MaterialApp(
        title: 'Dev Satay Consumer',
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
            ),
            body1: TextStyle(
              fontFamily: 'Play',
              fontSize: 16,
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
          PaymentScreen.routeName : (ctx) => PaymentScreen(),
          HistoryOrdersScreen.routeName : (ctx) => HistoryOrdersScreen(),
          TopupScreen.routeName : (ctx) => TopupScreen(),
          TopupPendingScreen.routeName : (ctx) => TopupPendingScreen(),
          TermsAndConditionScreen.routeName : (ctx) => TermsAndConditionScreen(),
          AboutUsScreen.routeName : (ctx) => AboutUsScreen(),
          UserProfile.routeName : (ctx) => UserProfile(),
          ProfileEdit.routeName : (ctx) => ProfileEdit()
        },
      ),
      )
    );
  }
}
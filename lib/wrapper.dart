

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/address/GoogleMapPage.dart';
import 'package:hammad_customer_0/address/SavedAddresses.dart';
import 'package:hammad_customer_0/home/home_screen.dart';
import 'package:hammad_customer_0/order/CustomerOrderPage.dart';
import 'package:hammad_customer_0/order/cart_screen.dart';
import 'package:hammad_customer_0/profile/profile_screen.dart';
import 'package:hammad_customer_0/redeemOffers.dart';
import 'package:hammad_customer_0/services/AuthState.dart';
import 'package:hammad_customer_0/services/UserService.dart';
import 'package:hammad_customer_0/theme.dart';
import 'package:provider/provider.dart';

import 'AuthPage.dart';



class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);


  @override
  _WrapperState createState() => _WrapperState();
}


class _WrapperState extends State<Wrapper> with SingleTickerProviderStateMixin {
  // void getfcm() async{
  //   print(await FirebaseMessaging.instance.getToken());
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final isUpdating = Provider.of<AuthUpdating>(context);

    if (user == null || isUpdating.isUpdatingValue == true) {
      return LoginScreen();
    }
    else {
      return StreamProvider.value(
          value: UserService(user.uid).getUserStream,
          initialData: null,
          child: MaterialApp(
            theme: theme(),
            routes:{ '/': (context) => HomeScreen(),
            'profile/': (context) => ProfileScreen(),
            'order/': (context) => OrderPage(),
            'redeem/': (context) => OffersScreen(),
            'addresses/': (context) => SavedAddresses(),
              'cart/': (context) => CartScreen(),
              'map/': (context) => GoogleMapPage(),
          },
          ));
    }
  }
}
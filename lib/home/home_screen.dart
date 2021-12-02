import 'package:flutter/material.dart';
import 'package:hammad_customer_0/LoadingPage.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModel>(context,listen: true);
    final textDirection = getTextDir(context);
    if (user != null) {
      return Directionality(
        textDirection: textDirection,
        child: Scaffold(
          body: Body(user: user,)
        ),
      );
    }
    return LoadingPage();
  }
}

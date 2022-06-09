import 'package:flutter/material.dart';
import 'package:hammad_customer_0/constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: kPrimaryColor,),),
    );
  }
}


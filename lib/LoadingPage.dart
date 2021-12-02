import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/constants.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connection = Provider.of<ConnectivityResult>(context);
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: kPrimaryColor,),),
    );
  }
}


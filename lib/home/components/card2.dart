import 'package:flutter/material.dart';
import 'package:hammad_customer_0/models/user_model.dart';
import 'package:hammad_customer_0/services/theme2.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Card2 extends StatelessWidget {
  final double height;
  final double width;
  final UserModel user;

  Card2({
    this.height,
    this.width,
    this.user,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        constraints: BoxConstraints.expand(
          width: width,
          height: height,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/water2.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: QrImage(
          // backgroundColor: Colors.white,
          data: "hammad://hammad.com/addPoints/?id=${user.id}",
          version: QrVersions.auto,
          backgroundColor: Colors.white70,
          size: 50.0,
        ),
      ),
    );
  }
}

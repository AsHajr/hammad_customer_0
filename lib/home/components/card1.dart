import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/user_model.dart';
import '../../services/theme2.dart';

class Card1 extends StatelessWidget {
  final UserModel user;
  final double height;
  final double width;

  Card1({
    this.height,
    this.width,
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 40,
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello ${user.firstName}",
              style: Theme2.lightTextTheme.headline2,
            ),
            Text(
              "${user.lastName}",
              style: Theme2.lightTextTheme.headline2,
            ),
            Text(
              "Your Points : ${user.points}",
              style: Theme2.lightTextTheme.headline3,
            ),
            TextButton(
              onPressed: () {},
              child: Text("Use Points"),
            )
          ],
        ),
        // padding: const EdgeInsets.all(5),
        constraints: BoxConstraints.expand(
          width: width,
          height: height,
        ),
        decoration: BoxDecoration(
          color: Colors.orange[300],
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}

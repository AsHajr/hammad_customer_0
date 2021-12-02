import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    accentColor: kPrimaryColor,
    checkboxTheme: checkboxTheme(),
  );
}

CheckboxThemeData checkboxTheme(){
  return CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
  );
}
InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    // contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
    labelStyle: TextStyle(color: Colors.black38),
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: kTextColor),
    bodyText2: TextStyle(color: kTextColor),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    centerTitle: true,
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle:  TextStyle(color: kSecondaryColor, fontSize: 18),
  );
}

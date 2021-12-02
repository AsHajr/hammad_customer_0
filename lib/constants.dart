import 'package:flutter/material.dart';
import 'package:hammad_customer_0/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:hammad_customer_0/translations/locale_keys.g.dart';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error

String kNamelNullError = LocaleKeys.please_enter_your_name.tr();
String kPhoneNumberNullError = LocaleKeys.please_enter_your_phone_number.tr();
String kAddressNullError = LocaleKeys.please_enter_your_address;
String kRequired = LocaleKeys.this_field_is_required.tr();
String kFailed = LocaleKeys.failed_to_modify.tr();



final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

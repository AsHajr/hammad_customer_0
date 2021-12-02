import 'package:flutter/material.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    final textDirection = getTextDir(context);
    return Directionality(
        textDirection: textDirection,
        child: Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.sign_up.tr()),
      ),
      body: Body(),
        ),
    );
  }
}

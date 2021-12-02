import 'package:flutter/material.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';

import 'components/body.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    final textDirection = getTextDir(context);
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.setting.tr()),
        ),
        body: Body(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import '../../constants.dart';
import '../../size_config.dart';
import 'sign_up_form.dart';
import 'package:easy_localization/easy_localization.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                  Text(LocaleKeys.register_account.tr(), style: headingStyle),
                  Text(
                    LocaleKeys.complete_your_details.tr(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SignUpForm(),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text(
                    LocaleKeys.terms_and_conditions.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}

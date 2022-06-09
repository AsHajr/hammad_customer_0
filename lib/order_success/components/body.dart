import 'package:flutter/material.dart';
import 'package:hammad_customer_0/components/default_button.dart';
import 'package:hammad_customer_0/home/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';

import '../../size_config.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Image.asset(
            "assets/images/success.png",
            height: SizeConfig.screenHeight * 0.15, //40%
          ),
          /// SizedBox(height: SizeConfig.screenHeight * 0.08),
          Text(
            LocaleKeys.order_placed.tr(),
            style: TextStyle(
              fontSize: getProportionateScreenWidth(30),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Spacer(),
          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: DefaultButton(
              text: LocaleKeys.back_to_home.tr(),
              press: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  HomeScreen()),
                      );
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

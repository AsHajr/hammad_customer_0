import 'package:flutter/material.dart';
import 'package:hammad_customer_0/services/googleMapApp.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../size_config.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(LocaleKeys.my_hammad.tr(), style: TextStyle(fontSize: 20),),
          // SearchField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {
                launch("tel://+962798590055");
              },
                icon: Icon(Icons.call_outlined),
                color: Colors.black,),
              IconButton(onPressed: () {
                MapUtils.openMap(32.0019135,35.9557119);
              },
                icon: Icon(Icons.directions_outlined),
                color: Colors.black,),
              IconButton(onPressed: () {
                Navigator.pushNamed(
                    context,
                    '/profile');
              },
                icon: Icon(Icons.settings_outlined), color: Colors.black,),
            ],
          ),
        ],
      ),
    );
  }
}

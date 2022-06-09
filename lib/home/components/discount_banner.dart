import 'package:flutter/material.dart';
import 'package:hammad_customer_0/models/user_model.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../size_config.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(20)),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFFFECDF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Your Points are : \n ${user.points}  ${LocaleKeys.points.tr()}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),

            QrImage(
              data: "hammad://hammad.com/addPoints/?id=${user.id}",
              version: QrVersions.auto,
              size: 120.0,
            ),
          ],
        ),
      ),
    );
  }
}

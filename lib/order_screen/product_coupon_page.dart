import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/models/cartItem.dart';
import 'package:hammad_customer_0/models/product.dart';
import 'package:hammad_customer_0/order/cart_screen.dart';
import 'package:hammad_customer_0/constants.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:hammad_customer_0/services/cartProvider.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:hammad_customer_0/size_config.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../components/coupon_card.dart';
import '../components/default_button.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';

import '../home/components/products_stream.dart';
import '../models/coupon.dart';
import '../services/Gen_database.dart';
import 'components/body.dart';

class ProductCouponOrder extends StatefulWidget {
  static String routeName = "/order";

  const ProductCouponOrder({Key key}) : super(key: key);
  @override
  _ProductCouponOrderState createState() => _ProductCouponOrderState();
}
class _ProductCouponOrderState extends State<ProductCouponOrder> {


  @override
  Widget build(BuildContext context) {
    final textDirection = getTextDir(context);
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.order.tr()),
          actions: [
            IconButton(onPressed: () {
              launch("tel://+962788590055");
            },
              icon: Icon(Icons.call_outlined),
              color: Colors.black,),
          ],
        ),
        body: Body(),

      ),
    );
  }
}


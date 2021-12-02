
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/home/components/pending_orders.dart';
import 'package:hammad_customer_0/home/components/previousOrders.dart';
import 'package:hammad_customer_0/home/components/products_stream.dart';
import 'package:hammad_customer_0/models/UserModel.dart';

import '../../../size_config.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  const Body({Key key, this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              HomeHeader(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenWidth(10)),
                  DiscountBanner(),
                  SpecialOffers(),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  PendingOrders(user: user,),
                  ProductsStream(),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  PreviousOrders(user: user,),
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ],
          ),
        ),
    );
  }
}

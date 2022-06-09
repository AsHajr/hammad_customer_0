import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/home/components/card2.dart';
import 'package:hammad_customer_0/home/components/pending_orders.dart';
import 'package:hammad_customer_0/home/components/previous_orders.dart';
import 'package:hammad_customer_0/home/components/products_stream.dart';
import 'package:hammad_customer_0/models/user_model.dart';

import '../../../size_config.dart';
import 'card1.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'special_offers.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({Key key, this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scan QR Code to get\npoints on each purchase :)',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.transparent,
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) =>
                        buildCard(index, user, 150, 150),
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 10);
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SpecialOffers(),
                PendingOrders(user: user),
                ProductsStream(),
                PreviousOrders(user: user),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildCard(int index, UserModel user, double width, double height) {
  if (index == 0) {
    return Card1(
      user: user,
      width: width,
      height: height,
    );
  } else if (index == 1) {
    return Card2(
      user: user,
      width: width,
      height: height,
    );
  }
}

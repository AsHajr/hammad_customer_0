import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/models/OrderModel.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:hammad_customer_0/services/cartProvider.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:hammad_customer_0/size_config.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'constants.dart';
import 'models/cartItem.dart';
import 'models/productModel.dart';

class PreviousOrdersScreen extends StatelessWidget {
  const PreviousOrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textDirection = getTextDir(context);
    final user = Provider.of<UserModel>(context, listen: false);
    return Directionality(
        textDirection: textDirection,
        child: Scaffold(
            appBar: AppBar(
              title: Text(LocaleKeys.previous_orders.tr()),
            ),
            body: StreamBuilder(
                stream: DatabaseService(context).getAllDeliveredOrdersStream(
                    user.id),
                builder: (context, snapshot) {
                  List<OrderModel> orders = [];
                  List<OrderModel> deliveredOrders = [];
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    orders = snapshot.data as List<OrderModel>;
                    deliveredOrders =
                        orders.where((element) => element.status == 'delivered')
                            .toList();
                    if (deliveredOrders.isNotEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: getProportionateScreenWidth(15)),
                           Container(
                              width: double.infinity,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: deliveredOrders.length,
                                  itemBuilder: (context, index) {
                                    return mOrderCard(
                                      order: deliveredOrders[index],
                                    );
                                  }),
                            ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }
                })
        ));
  }
}
class mOrderCard extends StatelessWidget {
  final OrderModel order;
  const mOrderCard({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: GestureDetector(
        onTap: () {
          CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
          cartProvider.cart = order.cart;
          cartProvider.cartPrice = double.parse(order.price) - double.parse(order.service);
          Navigator.pushNamed(context, 'order/');
          Navigator.pushNamed(context, 'cart/');
        },
        child: Container(
          width: getProportionateScreenWidth(280),
          height: 110,
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15.0),
            vertical: getProportionateScreenWidth(10),),
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryLightColor, width: 1),
            borderRadius: BorderRadius.circular(15),
            // color: color,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  // horizontal: getProportionateScreenWidth(15.0),
                  // vertical: getProportionateScreenWidth(10),
                ),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderProductStream(cartItem: order.cart.first,),
                        // order.cart.length > 1 ?
                        //   OrderProductStream(cartItem: order.cart.last,):Container(),
                        order.cart.length > 2 ?Text("+${order.cart.length - 1} ${LocaleKeys.more.tr()}"):Container(),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child:
                 Row(
                    children: [
                      Icon(Icons.refresh_outlined),
                      Text(LocaleKeys.reorder.tr(),
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.bold,
                        ),)
                    ],
                  ),
                ),
              getLang(context) ?
              Positioned(
                  left: 0,
                  top: 0,
                  child: statusText()
              ): Positioned(
                  right: 0,
                  top: 0,
                  child: statusText()
              ),
              getLang(context) ?
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: priceText()
              ): Positioned(
                  right: 0,
                  bottom: 0,
                  child: priceText()
              ),
            ],
          ),
        ),
      ),
    );
  }
  Padding statusText(){
    return Padding(
        padding: EdgeInsets.symmetric(
          // horizontal: getProportionateScreenWidth(15.0),
          // vertical: getProportionateScreenWidth(10),
        ),child:
    Text(LocaleKeys.delivered.tr(),
      style: TextStyle(
        fontSize: getProportionateScreenWidth(14),
        fontWeight: FontWeight.bold,
      ),
    )
    );
  }
  Padding priceText(){
    return  Padding(padding: EdgeInsets.symmetric(
    ),child:
    Text("${LocaleKeys.jod.tr()} ${order.price}",
      style: TextStyle(
        fontSize: getProportionateScreenWidth(14),
        fontWeight: FontWeight.bold,
      ),
    )
    );
  }
}
class OrderProductStream extends StatelessWidget {
  final CartItem cartItem;

  OrderProductStream({Key key, this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: DatabaseService(context).getProductStream(cartItem.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data as Product;
            return Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "${cartItem.quantity}X ${product.title}",
                  ),
                ],
              ),
            );
          }
          return Container();
        }
    );
  }
}

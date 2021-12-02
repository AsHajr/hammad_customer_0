import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/constants.dart';
import 'package:hammad_customer_0/models/OrderModel.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:hammad_customer_0/models/cartItem.dart';
import 'package:hammad_customer_0/models/productModel.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';

import '../../size_config.dart';


class PendingOrders extends StatelessWidget {
  final UserModel user;
  const PendingOrders({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService(context).getOrdersStream(user.id),
        builder: (context,snapshot){
          List<OrderModel> orders = [];
          List<OrderModel> deliveredOrders = [];
          if (!snapshot.hasData){
            return
              Container();
           }else{
            orders = snapshot.data as List<OrderModel>;
            deliveredOrders = orders.where((element) => element.status == 'pending').toList();
            if(deliveredOrders.isEmpty){
              return Container();
            }else{
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:getProportionateScreenWidth(20)),
                    child: Text(LocaleKeys.waiting_to_be_delivered.tr(),style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: Colors.black,
                      ),),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Container(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: deliveredOrders.length,
                        itemBuilder: (context, index)
                        {
                          return pOrderCard(
                            order: deliveredOrders[index],
                          );
                        }),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              );
            }
          }
        }
    );
  }
}
class pOrderCard extends StatelessWidget {
  final OrderModel order;
  const pOrderCard({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = getPaddingDir(context);
    return Padding(
      padding: padding,
      child: Container(
          width: getProportionateScreenWidth(280),
          height: 110,
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15.0),
            vertical: getProportionateScreenWidth(10),),
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor, width: 1),
            borderRadius: BorderRadius.circular(15),
            // color: color,
          ),
          child: Stack(
            children: [
              Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderProductStream(cartItem: order.cart.first,),
                        order.cart.length > 1 ?
                          OrderProductStream(cartItem: order.cart[1],):Container(),
                        order.cart.length == 3 ?
                        OrderProductStream(cartItem: order.cart.last,):Container(),
                        order.cart.length > 3 ?Text("+${order.cart.length - 2} ${LocaleKeys.more.tr()}"):Container(),
                      ],
                    ),
                  ],
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
    );
  }
  Padding statusText(){
    return Padding(
        padding: EdgeInsets.symmetric(
          // horizontal: getProportionateScreenWidth(15.0),
          // vertical: getProportionateScreenWidth(10),
        ),child:
    Text(LocaleKeys.pending.tr(),
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
    ),
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

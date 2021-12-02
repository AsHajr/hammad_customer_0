import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/PreviousOrdersScreen.dart';
import 'package:hammad_customer_0/components/default_button.dart';
import 'package:hammad_customer_0/components/order_card.dart';
import 'package:hammad_customer_0/home/components/section_title.dart';
import 'package:hammad_customer_0/models/OrderModel.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';

import '../../size_config.dart';


class PreviousOrders extends StatelessWidget {
  final UserModel user;
  const PreviousOrders({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService(context).getOrdersStream(user.id),
        builder: (context,snapshot){
          List<OrderModel> orders = [];
          List<OrderModel> deliveredOrders = [];
          if (!snapshot.hasData){
            return
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DefaultButton(
                  press: (){
                    Navigator.pushNamed(context, 'order/');
                  },
                  text: LocaleKeys.order.tr(),
                ),
              );
          }else{
            orders = snapshot.data as List<OrderModel>;
            deliveredOrders = orders.where((element) => element.status == 'delivered').toList();
            if(deliveredOrders.isEmpty){
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: DefaultButton(
                  press: (){
                    Navigator.pushNamed(context, 'order/');
                  },
                  text: LocaleKeys.order.tr(),
                ),
              );
            }else{
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                    child: SectionTitle(
                      title: LocaleKeys.previous_orders.tr(),
                      press: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PreviousOrdersScreen()));
                      },
                    ),
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
                          return OrderCard(
                            order: deliveredOrders[index],
                          );

                        }),
                  )
                ],
              );

            }
          }
        }
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/models/cartItem.dart';
import 'package:hammad_customer_0/models/coupon.dart';
import 'package:hammad_customer_0/models/product.dart';
import 'package:hammad_customer_0/constants.dart';
import 'package:hammad_customer_0/models/user_model.dart';
import 'package:hammad_customer_0/order_screen/cart_screen.dart';
import 'package:hammad_customer_0/services/cart_provider.dart';

import 'package:hammad_customer_0/size_config.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:hammad_customer_0/translations/locale_keys.g.dart';

import '../../components/coupon_card.dart';
import '../../components/default_button.dart';
import '../../components/product_card.dart';
import '../../services/Gen_database.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CouponsStream(),
              SizedBox(height: 10,),
              ProductsStream(),
              SizedBox(height: 10,),
                GoToBasketButton(
                  text: "${LocaleKeys.basket.tr()}",
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                ),

            ],
          ),
        ));
  }

  void _showBottomSheet(Product product) {
    int quantity = 1;
    double price = product.price;
    CartProvider cartProvider;
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0, bottom: 20),
              child: SingleChildScrollView(
                  child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: getProportionateScreenHeight(135),
                      height: getProportionateScreenHeight(165),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  product.imageUrl,
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ))),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(19)),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text('${price.toStringAsFixed(2)} JOD',
                                style: TextStyle(
                                    fontSize:
                                        getProportionateScreenHeight(18))),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (quantity != 1) {
                                    setSheetState(() {
                                      quantity -= 1;
                                      price -= product.price;
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: kPrimaryColor,
                                )),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                '$quantity',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setSheetState(() {
                                    quantity += 1;
                                    price += product.price;
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: kPrimaryColor,
                                )),
                          ],
                        ),
                      ]),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                  GoToBasketButton(
                    text: LocaleKeys.add_to_basket.tr(),
                    press: () {
                      if (cartProvider.cartValue
                          .any((item) => item.id == product.id)) {
                        final i = cartProvider.cartValue.firstWhere(
                            (element) => element.id == product.id,
                            orElse: () => null);
                        setState(() {
                          i.quantity += quantity;
                          cartProvider.addToPrice(price);
                        });
                      } else {
                        setState(() {
                          cartProvider.addToCart(
                              CartItem(product.id, quantity), price);
                        });
                      }
                      Navigator.pop(context);
                    },
                  )
                ],
              )),
            );
          });
        });
  }

  StreamBuilder ProductsStream() {
    return StreamBuilder<Object>(
        stream: GenDatabaseService(context).getProductsStream,
        builder: (context, snapshot) {
          var productCards = <ProductCard>[];
          if (snapshot.hasData) {
            final productList = snapshot.data as List<Product>;
            productCards.addAll(productList.map((e) => ProductCard(
                product: e,
                press: () {
                  _showBottomSheet(e);
                })));
            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              child: GridView.builder(
                itemCount: productList.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final simpleProduct = productList[index];
                  return ProductCard(product: simpleProduct);
                },
              ),
            );

            //     GridView.count(
            //       shrinkWrap: true,
            //       crossAxisCount: 2,
            //       childAspectRatio: .8,
            //       mainAxisSpacing: 10,
            //       crossAxisSpacing: 20,
            //       physics: NeverScrollableScrollPhysics(),
            //       padding: EdgeInsets.only(bottom: getProportionateScreenHeight(56)+20),
            //       children: productCards);
          }
          return CircularProgressIndicator();
        });
  }

  StreamBuilder CouponsStream() {
    return StreamBuilder<Object>(
        stream: GenDatabaseService(context).getAllCouponsStream,
        builder: (context, snapshot) {
          var couponCards = <CouponCard>[];
          if (snapshot.hasData) {
            final couponList = snapshot.data as List<Coupon>;
            couponCards.addAll(
                couponList.map((e) => CouponCard(coupon: e, press: () {})));
            return CouponCard(

              press: () {},
            );


            //     GridView.count(
            //       shrinkWrap: true,
            //       crossAxisCount: 2,
            //       childAspectRatio: .8,
            //       mainAxisSpacing: 10,
            //       crossAxisSpacing: 20,
            //       physics: NeverScrollableScrollPhysics(),
            //       padding: EdgeInsets.only(bottom: getProportionateScreenHeight(56)+20),
            //       children: couponCards);
            // }

          }
          return CircularProgressIndicator();
        });
  }
}

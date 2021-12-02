import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/components/product_card.dart';
import 'package:hammad_customer_0/models/cartItem.dart';
import 'package:hammad_customer_0/models/productModel.dart';
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
import '../components/default_button.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';



class OrderPage extends StatefulWidget {
  const OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}



class _OrderPageState extends State<OrderPage> {
  UserModel user;
  CartProvider cartProvider;

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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Stack(
            children: [
              productsStream(),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: DefaultButton(
                    text: "${LocaleKeys.basket.tr()}", press: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => CartScreen()));
                  },),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
  }

  void _showBottomSheet(Product product) {
    int quantity = 1;
    double price = double.parse(product.price);
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
                                        image: NetworkImage(product.imageUrl,),
                                        fit: BoxFit.contain,
                                      ),
                                    ),))),
                          SizedBox(height: getProportionateScreenHeight(20),),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.title,style: TextStyle(fontSize: getProportionateScreenHeight(19)),),
                                    SizedBox(height: 15,),
                                    Text('${price.toStringAsFixed(2)} JOD',style: TextStyle(fontSize: getProportionateScreenHeight(18))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(onPressed: () {
                                      if(quantity != 1){
                                          setSheetState(() {
                                            quantity -= 1;
                                            price -= double.parse(product.price);
                                          });
                                      }
                                    },
                                        icon: Icon(
                                          Icons.remove, color: kPrimaryColor,)),
                                    Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Text('$quantity',
                                        style: TextStyle(fontSize: 18),),
                                    ),
                                    IconButton(onPressed: () {
                                      setSheetState(() {
                                        quantity += 1;
                                        price += double.parse(product.price);
                                      });
                                    },
                                        icon: Icon(
                                          Icons.add, color: kPrimaryColor,)),
                                  ],
                                ),
                              //   ButtonPicker(
                              //     minValue: 1,
                              //     maxValue: 50,
                              //     initialValue: 1,
                              //     onChanged: (val) {
                              //       quantity = val.ceil();
                              //       setSheetState(() {
                              //         price = double.parse(product.price) *
                              //             quantity;
                              //       });
                              //     },
                              //     step: 1,
                              //     horizontal: true,
                              //     loop: false,
                              //     padding: 5.0,
                              //     iconLeft: Icons.remove,
                              //     iconRight: Icons.add,
                              //     iconUpRightColor: kPrimaryColor,
                              //     iconDownLeftColor: kPrimaryColor,
                              //     style: TextStyle(
                              //       fontSize: 18.0,
                              //     ),
                              //   ),
                              ]),
                          SizedBox(height: getProportionateScreenHeight(25),),
                          DefaultButton(text: LocaleKeys.add_to_basket.tr(), press: () {
                            if (cartProvider.cartValue.any((item) => item.id == product.id)) {
                              final i = cartProvider.cartValue.firstWhere((element) =>
                              element.id == product.id, orElse: () => null);
                              setState(() {
                                i.quantity += quantity;
                                cartProvider.addToPrice(price);
                              });
                            } else {
                              setState(() {
                                cartProvider.addToCart(CartItem(product.id, quantity),price);
                              });
                            }
                            Navigator.pop(context);
                          },)
                        ],
                      )
                  ),
                );
              });
        });
  }
  StreamBuilder productsStream(){
    return StreamBuilder<Object>(
        stream: DatabaseService(context).getProductsStream,
        builder: (context, snapshot) {
          var productCards = <ProductCard>[];
          if (snapshot.hasData) {
            final productList = snapshot.data as List<Product>;
            productCards.addAll(
                productList.map((e) =>
                    ProductCard(product: e,press: (){_showBottomSheet(e);},aspectRetio: 1.2,)));
            return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: .8,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
                padding: EdgeInsets.only(bottom: getProportionateScreenHeight(56)+20),
                children: productCards);
          }
          return SizedBox();
        }
    );
  }
}
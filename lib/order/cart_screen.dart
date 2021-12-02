import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hammad_customer_0/components/addAddressButton.dart';
import 'package:hammad_customer_0/components/default_button.dart';
import 'package:hammad_customer_0/models/AddressModel.dart';
import 'package:hammad_customer_0/models/OrderModel.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:hammad_customer_0/models/cartItem.dart';
import 'package:hammad_customer_0/models/productModel.dart';
import 'package:hammad_customer_0/services/cartProvider.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:hammad_customer_0/services/snackBar.dart';
import 'package:hammad_customer_0/size_config.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final notesCont = TextEditingController();
  List<AddressModel> addresses = [];
  AddressModel address;
  AddressModel pAddress;
  UserModel user;
  TextStyle _textStyle = TextStyle(fontWeight: FontWeight.bold,);
  CartProvider cartProvider;


  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context,listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
  }


  @override
  void dispose() {
    notesCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = getTextDir(context);
    final connection = Provider.of<ConnectivityResult>(context);
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.basket.tr()),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
              child: Column(
              children: [
                addressesStreamBuilder(),
                SizedBox(height: getProportionateScreenHeight(30),),
                cartList(),
                SizedBox(height: getProportionateScreenHeight(30),),
                noteColumn(),
                SizedBox(height: getProportionateScreenHeight(30),),
                paymentSummary(),
                SizedBox(height: 20,),
                DefaultButton(text: LocaleKeys.place_order.tr(),press: (){
                  if(connection != ConnectivityResult.wifi && connection != ConnectivityResult.mobile){
                    showSnackBar(context, LocaleKeys.no_connection.tr());
                  }else{
                    if(cartProvider.cartValue.isEmpty) {
                      showSnackBar(context, LocaleKeys.no_items_selected
                          .tr());
                      } else {
                        if (address == null) {
                          showSnackBar(context, LocaleKeys.no_address_selected
                              .tr());
                      }else{
                          final total = cartProvider.priceValue+1;
                          final points = int.parse(user.points) + total.round();
                          OrderModel order = OrderModel(
                              "",
                              user.id,
                              address.id,
                              cartProvider.cartValue,
                              "${total.toStringAsFixed(2)}",
                              notesCont.text,
                              "",
                              "","1");
                          DatabaseService(context).writeNewOrder(order);
                          DatabaseService(context).updateUserPoints(user.id, "$points");
                          cartProvider.cart.clear();
                          cartProvider.cartPrice = 0;
                          Navigator.pushReplacementNamed(context, "/");
                        }
                    }
                  }
                },),
              ],
          ),
            ),
        ),
        ),
    );
  }
  Future<void> mShowDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Text(LocaleKeys.select_address.tr()),
            children: <Widget>[
              Column(
                children: <Widget>[
                  for (int i = 0; i < addresses.length; i++)
                    SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          pAddress = addresses[i];
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        '${addresses[i].nickName},${addresses[i].area},${addresses[i].street}',
                      ),
                    ),
                ],
              ),
              // addAddressButton(context),
            ]);
      },
    );
  }
  ListView cartList () {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: cartProvider.cartValue.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context,index) {
          return ItemCard(cartItem: cartProvider.cartValue[index], onSelectParam: (double val){
            setState(() {
              cartProvider.cartPrice +=(val);
            });
          },on0se: (){
            cartProvider.removeFromCart(index);
          },);
        });
  }
  StreamBuilder addressesStreamBuilder () {
    return  StreamBuilder(
        stream: DatabaseService(context).getAddressesStream(
            user.id),
        builder: (context, snapshot) {
          addresses = [];
          if (snapshot.hasData) {
            addresses = snapshot.data as List<AddressModel>;
            if (pAddress == null) {
              address = addresses.first;
            } else {
              address = pAddress;
            }
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: kSecondaryColor, width: .5),
                  borderRadius: BorderRadius.circular(18)
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            heightFactor: 0.3,
                            widthFactor: 2.5,
                            child:
                            AbsorbPointer(
                                absorbing: true,
                                child: GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                        target: address
                                            .latLng,
                                        zoom: 15),
                                    zoomControlsEnabled: false,
                                    gestureRecognizers: {
                                      Factory<
                                          OneSequenceGestureRecognizer>(() =>
                                          ScaleGestureRecognizer()),
                                    }
                                )
                            ),
                          ),),
                        Positioned(
                            top: FractionalOffset.center
                                .y -
                                getProportionateScreenHeight(
                                    45),
                            bottom: FractionalOffset
                                .center.y,
                            right: FractionalOffset.center
                                .y,
                            left: FractionalOffset.center
                                .y,

                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5,vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                              color: kSecondaryColor,),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: <Widget>[
                                Text('${address.nickName}(${address
                                    .area})',
                                ),
                                Text('${address.floor},${address
                                    .buildingNo},${address
                                    .street}',
                                ),
                                SizedBox(height: 5,),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                          ),
                          onPressed: () {
                            mShowDialog();
                          },
                          child: Text(LocaleKeys.change.tr()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocaleKeys.address.tr(), style: TextStyle(
                  fontSize: getProportionateScreenWidth(16.5),
                  fontWeight: FontWeight.bold,
                ),),
                addAddressButton(context)
              ],
            );
        });
  }
  Column noteColumn(){
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.mode_comment_outlined,color: kSecondaryColor,),
            SizedBox(width: 5,),
            Text(LocaleKeys.add_a_note.tr(),style:TextStyle(color: kSecondaryColor,)),
          ],
        ),
        TextFormField(
          controller: notesCont,
          decoration: InputDecoration(
              hintText: LocaleKeys.anything_else_we_need_to_know.tr()
          ),
        )
      ],
    );
  }
  Padding paymentSummary(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.payment.tr(), style: TextStyle(
            fontSize: getProportionateScreenWidth(18.5),
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(LocaleKeys.price.tr(),style: _textStyle), Text('${cartProvider.priceValue} ${LocaleKeys.jod.tr()}',style: _textStyle),],),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(LocaleKeys.delivery.tr(),style: _textStyle), Text("1${LocaleKeys.jod.tr()}",style: _textStyle),],),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(LocaleKeys.total.tr(),style: _textStyle), Text('${cartProvider.priceValue + 1}${LocaleKeys.jod.tr()}',style: _textStyle),],),
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  CartItem cartItem;
  Function(double) onSelectParam;
  Function on0se;
  ItemCard({Key key, this.cartItem, this.onSelectParam,this.on0se}) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  double price;
  int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.cartItem.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService(context).getProductStream(widget.cartItem.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Product product = snapshot.data as Product;
            price = double.parse(product.price);
            return Container(
              padding: EdgeInsets.only(bottom: 20),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(width: 20,),
                  SizedBox(
                    width: SizeConfig.screenWidth -
                        getProportionateScreenWidth(120),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${LocaleKeys.jod.tr()} ${(double.parse(product.price) *
                                widget.cartItem.quantity.toDouble()).toStringAsFixed(2)}"),
                            Row(
                              children: [
                                IconButton(onPressed: () {
                                  setState(() {
                                    widget.cartItem.quantity -= 1;
                                  });
                                  widget.onSelectParam(-1 * price);
                                  if (widget.cartItem.quantity == 0) {
                                    widget.on0se();
                                  }
                                },
                                    icon: Icon(
                                      Icons.remove, color: kPrimaryColor,)),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text('${widget.cartItem.quantity}',
                                    style: TextStyle(fontSize: 18),),
                                ),
                                IconButton(onPressed: () {
                                  widget.onSelectParam(1 * price);
                                  setState(() {
                                    widget.cartItem.quantity += 1;
                                  });
                                },
                                    icon: Icon(
                                      Icons.add, color: kPrimaryColor,)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: getProportionateScreenWidth(80),
                      height: getProportionateScreenHeight(80),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child:
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(product.imageUrl,),
                                fit: BoxFit.fill,
                              ),
                            ),)))
                ],
              ),
            );
          }
          return Container();
        });
  }
}

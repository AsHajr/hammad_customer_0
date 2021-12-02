import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/LoadingPage.dart';
import 'package:hammad_customer_0/constants.dart';
import 'package:hammad_customer_0/services/UserService.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:hammad_customer_0/services/snackBar.dart';
import 'package:hammad_customer_0/size_config.dart';
import 'package:provider/provider.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'models/OfferModel.dart';
import 'models/RedeemOffers.dart';
import 'models/UserModel.dart';

class OffersScreen extends StatefulWidget {
  static String routeName = "/redeem";
  const OffersScreen({Key key}) : super(key: key);

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  List<OfferModel> offers;
  List<OfferModel> validOffers;
  UserModel user;


  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = getTextDir(context);
    final connection = Provider.of<ConnectivityResult>(context);
    if (connection != ConnectivityResult.wifi &&
        connection != ConnectivityResult.mobile) {
      return LoadingPage();
    } else {
      return Directionality(
        textDirection: textDirection,
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.offers.tr()),
          ),
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: UserService(user.id).getUserStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    user = snapshot.data as UserModel;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PointsCard(points: user.points,),
                          Padding(
                              padding:
                              EdgeInsets.all(getProportionateScreenWidth(20)),
                              child: Text(
                                LocaleKeys.my_offers.tr(), style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.bold,
                              ),)
                          ),
                          StreamBuilder(
                              stream: DatabaseService(context)
                                  .getWaitingOffersStream(
                                  user.id),
                              builder: (context, snapshot) {
                                List<RedeemedOffers> rOffers = [];
                                offers = [];
                                if (snapshot.hasData) {
                                  rOffers =
                                  snapshot.data as List<RedeemedOffers>;
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: rOffers.length,
                                        itemBuilder: (context, index) =>
                                            StreamBuilder<Object>(
                                                stream: DatabaseService(context)
                                                    .getOfferStream(
                                                    rOffers[index].offerId),
                                                builder: (context, snapshot) {
                                                  OfferModel offer;
                                                  if (snapshot.hasData) {
                                                    offer =
                                                    snapshot.data as OfferModel;
                                                    return MyOffers(
                                                      offer: offer,
                                                      press: () {},);
                                                  }
                                                  return Container();
                                                }
                                            )
                                    ),
                                  );
                                }
                                return
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(LocaleKeys.no_offers_yet.tr()),
                                  );
                              }
                          ),
                          Divider(thickness: 2, height: 20,),
                          Padding(
                              padding:
                              EdgeInsets.all(getProportionateScreenWidth(10)),
                              child: Text(
                                LocaleKeys.offers.tr(), style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.bold,
                              ),)
                          ),
                          StreamBuilder(
                              stream: DatabaseService(context).getOffersStream,
                              builder: (context, snapshot) {
                                offers = [];
                                validOffers = [];
                                if (snapshot.hasData) {
                                  offers = snapshot.data as List<OfferModel>;
                                  validOffers = offers.where((element) {
                                    return DateTime.now().isBefore(
                                        DateTime.parse(element.expiryDate)) &&
                                        DateTime.now().isAfter(
                                            DateTime.parse(element.startDate));
                                  }).toList();
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: validOffers.length,
                                      itemBuilder: (context, index) =>

                                          OffersCard(
                                            offer: validOffers[index],
                                            user: user,)

                                  );
                                }
                                return
                                  Text(LocaleKeys.no_offers_yet.tr());
                              }
                          ),
                        ]
                    );
                  }
                  return Container();
                }
            ),
          ),
        ),
      );
    }
  }
}
class MyOffers extends StatelessWidget {
  const MyOffers({Key key, this.offer, this.press}) : super(key: key);

  final OfferModel offer;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    final padding = getPaddingDir(context);
    return Padding(
      padding: padding,
      child: Column(
        children: [
          SizedBox(
            width: 85,
            height: 85,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(offer.imageUrl,),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF343434).withOpacity(0.4),
                            Color(0xFF343434).withOpacity(0.15),
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: getProportionateScreenWidth(15.0),
                    //     vertical: getProportionateScreenWidth(10),
                    //   ),
                    //   child: Text.rich(
                    //     TextSpan(
                    //       style: TextStyle(color: Colors.white),
                    //       children: [
                    //         TextSpan(
                    //           text: "${offer.description}\n",
                    //           style: TextStyle(
                    //             fontSize: getProportionateScreenWidth(18),
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         TextSpan(text: "${offer.subDescription} ")
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(85),
            height: getProportionateScreenHeight(60),
            child: Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "${offer.title}\n",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class OffersCard extends StatelessWidget {
  const OffersCard({Key key, this.offer, this.user}) : super(key: key);

  final OfferModel offer;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final DateTime expiryDate = DateTime.parse(offer.expiryDate);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(20), getProportionateScreenWidth(20),
          getProportionateScreenWidth(20), 0),
      child: SizedBox(
        width: 300,
        height: 145,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF343434).withOpacity(0.02),
                      Color(0xFF343434).withOpacity(0.02),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: FractionalOffset.center.x,
                right: FractionalOffset.center.x,
                child: Container(
                  width: SizeConfig.screenWidth,
                  child: TextButton(
                      onPressed: () async{
                        if (int.parse(user.points) >= int.parse(offer.points)) {
                          RedeemedOffers myOffer = new RedeemedOffers(
                              '', offer.id, 'waiting');
                          await DatabaseService(context).writeRedeemedOffer(
                              user, myOffer, offer.points);
                        } else {
                          showSnackBar(context, LocaleKeys.you_dont_have_enough_points.tr());
                        }
                      }, child: Text(LocaleKeys.redeem.tr(),
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(17),
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15.0),
                  vertical: getProportionateScreenWidth(10),
                ),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "${offer.title}\n",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "${LocaleKeys.points.tr()} ${offer.points}\n"),

                      TextSpan(text: "${LocaleKeys.valid_till.tr()} ${DateFormat.yMMMd().format(expiryDate)} "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class PointsCard extends StatelessWidget {
  final String points;
  const PointsCard({Key key, this.points}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          // width: getProportionateScreenWidth(300),
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFECDF).withOpacity(0.2),
                        Color(0xFFFFECDF).withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "${LocaleKeys.my_points.tr()}\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(17),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "${LocaleKeys.points.tr()} $points\n"),
                        // TextSpan(text: "Valid till: ${"offer.expiryDate"} "),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



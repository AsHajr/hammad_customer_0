import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/models/OfferModel.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:hammad_customer_0/translations/locale_keys.g.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class SpecialOffers extends StatefulWidget {
  const SpecialOffers({
    Key key,
  }) : super(key: key);

  @override
  _SpecialOffersState createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  List<OfferModel> offers;
  List<OfferModel> validOffers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: LocaleKeys.redeem_points.tr(),
            press: () {
                Navigator.pushNamed(context, 'redeem/');
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        StreamBuilder(
            stream: DatabaseService(context).getOffersStream,
            builder: (context, snapshot){
              offers = [];
              validOffers = [];
              if(snapshot.hasData) {
                offers = snapshot.data as List<OfferModel>;
                validOffers = offers.where((element) {
                  return DateTime.now().isBefore(
                      DateTime.parse(element.expiryDate)) &&
                      DateTime.now().isAfter(
                          DateTime.parse(element.startDate));
                }).toList();
                return Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: validOffers.length,
                      itemBuilder: (context, index) =>
                          SpecialOfferCard(
                            offer: validOffers[index],)
                  ),
                );
              }
              return
                Container();
            }
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key key,
    this.offer,
  }) : super(key: key);

  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    final padding = getPaddingDir(context);
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "redeem/");
      },
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: getProportionateScreenWidth(300),
          // height: getProportionateScreenHeight(145),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(offer.imageUrl,),
                  fit: offer.boxFit,
                ),
              ), child: Stack(
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "${offer.description}\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "${offer.subDescription} ")
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/home/components/section_title.dart';
import 'package:hammad_customer_0/models/productModel.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ProductsStream extends StatelessWidget {
  const ProductsStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: LocaleKeys.products.tr(),
            press: () {
              Navigator.pushNamed(context, 'order/');
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        StreamBuilder(
            stream: DatabaseService(context).getProductsStream,
            builder: (context,snapshot){
              List<Product> products = [];
              if (snapshot.hasData){
                products = snapshot.data as List<Product>;
                return Container(
                  height: 175,
                  width: double.infinity,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index)
                      {
                        return ProductCard(
                         product: products[index],press: (){
                           Navigator.pushNamed(context, 'order/');
                        }
                        );
                      }),
                );
              }return Container();
            }),
      ],
    );
  }
}
class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.product, this.press,
  }) : super(key: key);

  final Function press;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: (press),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 125,
                width: 115,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network("${product.imageUrl}",),
              ),
            Text(
              "${product.title}",
              style: TextStyle(color: Colors.black,
                fontSize: 16.2,
                // fontWeight: FontWeight.w200,
              ),
              maxLines: 2,
            ),

            Text(
              "${product.price}JOD",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

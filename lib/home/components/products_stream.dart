import 'package:flutter/material.dart';
import 'package:hammad_customer_0/home/components/section_title.dart';
import 'package:hammad_customer_0/models/product.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../services/gen_database.dart';

class ProductsStream extends StatelessWidget {
  const ProductsStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: LocaleKeys.products.tr(),
          press: () {
            Navigator.pushNamed(context, 'order_screen/');
          },
        ),
        SizedBox(height: 20),
        StreamBuilder(
            stream: GenDatabaseService(context).getProductsStream,
            builder: (context, snapshot) {
              List<Product> products = [];
              if (snapshot.hasData) {
                products = snapshot.data as List<Product>;
                return GridView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                          product: products[index],
                          press: () {
                            Navigator.pushNamed(context, 'order_screen/');
                          });
                    });
              }
              return Container();
            }),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  final Function press;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (press),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  child: Image.network(
                    "${product.imageUrl}",
                    fit: BoxFit.fitWidth,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${product.title}",
                style: Theme.of(context).textTheme.bodyText1,
                maxLines: 2,
              ),
              const SizedBox(height: 5),
              Text(
                "${product.price}JOD",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

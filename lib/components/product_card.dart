import 'package:flutter/material.dart';
import 'package:hammad_customer_0/models/productModel.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.width = 110,
    this.aspectRetio = 1.02,
    this.product, this.press,
  }) : super(key: key);

  final double width, aspectRetio;
  final Function press;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (press),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: aspectRetio,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  // decoration: BoxDecoration(
                  //   color: kSecondaryColor.withOpacity(0.05),
                  //   borderRadius: BorderRadius.circular(15),
                  // ),
                    child: Image.network("${product.imageUrl}",),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${product.title}",
                style: TextStyle(color: Colors.black,
                fontSize: getProportionateScreenWidth(15.5),
                  // fontWeight: FontWeight.w200,
                ),
                maxLines: 2,
              ),

              Text(
                "${product.price}JOD",
                style: TextStyle(
                //   fontSize: getProportionateScreenWidth(18),
                //   fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
    );
  }
}

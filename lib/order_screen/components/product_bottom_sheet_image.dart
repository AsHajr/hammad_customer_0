import 'package:flutter/cupertino.dart';

import '../../size_config.dart';

class ProductImage extends StatelessWidget {
  final String image;
  const ProductImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: getProportionateScreenHeight(135),
        height: getProportionateScreenHeight(165),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.contain,
                ),
              ),)));
  }
}

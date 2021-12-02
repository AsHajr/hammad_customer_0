import 'package:flutter/material.dart';
import 'package:hammad_customer_0/constants.dart';

import '../../../size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    this.title,
    this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              color: Colors.black,
            ),
          ),
          Icon(
            // onPressed: (press),
        Icons.arrow_forward_ios_sharp, color: kSecondaryColor,),
              // style: TextStyle(color: Color(0xFFBBBBBB)),
          // ),
        ],
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
//
// import '../../constants.dart';
// import '../../services/checkLanguage.dart';
// import '../../size_config.dart';
//
// class CouponSection extends StatelessWidget {
//   const CouponSection({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final padding = getPaddingDir(context);
//     return Padding(
//       padding: padding,
//       child: GestureDetector(
//         onTap: () {
//           CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
//           cartProvider.cart = order_screen.cart;
//           cartProvider.cartPrice = double.parse(order_screen.price) - double.parse(order_screen.service);
//           Navigator.pushNamed(context, 'order_screen/');
//           Navigator.pushNamed(context, 'cart/');
//         },
//         child: Container(
//           width: getProportionateScreenWidth(280),
//           height: 110,
//           padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15.0),
//             vertical: getProportionateScreenWidth(10),),
//           decoration: BoxDecoration(
//             border: Border.all(color: kPrimaryLightColor, width: 1),
//             borderRadius: BorderRadius.circular(15),
//             // color: color,
//           ),
//           child: Stack(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   // horizontal: getProportionateScreenWidth(15.0),
//                   // vertical: getProportionateScreenWidth(10),
//                 ),
//                 child: Column(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         OrderProductStream(cartItem: order_screen.cart.first,),
//                         // order_screen.cart.length > 1 ?
//                         //   OrderProductStream(cartItem: order_screen.cart.last,):Container(),
//                         order_screen.cart.length > 2 ?Text("+${order_screen.cart.length - 1} ${LocaleKeys.more.tr()}"):Container(),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child:
//                 Row(
//                   children: [
//                     Icon(Icons.refresh_outlined),
//                     Text(LocaleKeys.reorder.tr(),
//                       style: TextStyle(
//                         fontSize: getProportionateScreenWidth(14),
//                         fontWeight: FontWeight.bold,
//                       ),)
//                   ],
//                 ),
//               ),
//               getLang(context) ?
//               Positioned(
//                   left: 0,
//                   top: 0,
//                   child: statusText()
//               ): Positioned(
//                   right: 0,
//                   top: 0,
//                   child: statusText()
//               ),
//               getLang(context) ?
//               Positioned(
//                   left: 0,
//                   bottom: 0,
//                   child: priceText()
//               ): Positioned(
//                   right: 0,
//                   bottom: 0,
//                   child: priceText()
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

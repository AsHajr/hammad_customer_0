// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../../size_config.dart';
//
// class Categories extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> categories = [
//       {"icon": "assets/icons/Cart Icon.svg", "text": "order_screen Now",'press':(){print('hi');}},
//       // {"icon": "assets/icons/Directions.svg", "text": "Bill"},
//       // {"icon": "assets/icons/Location point.svg", "text": "Game"},
//
//     ];
//     return Padding(
//       padding: EdgeInsets.all(getProportionateScreenWidth(20)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: List.generate(
//           categories.length,
//           (index) => CategoryCard(
//             icon: categories[index]["icon"],
//             text: categories[index]["text"],
//             press:categories[index]["press"],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class CategoryCard extends StatelessWidget {
//   const CategoryCard({
//     Key key,
//     this.icon,
//     this.text,
//     this.press,
//   }) : super(key: key);
//
//   final String icon, text;
//   final GestureTapCallback press;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: press,
//       child: SizedBox(
//         width: getProportionateScreenWidth(150),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(getProportionateScreenWidth(8)),
//               height: getProportionateScreenWidth(85),
//               width: getProportionateScreenWidth(150),
//               decoration: BoxDecoration(
//                 // color: Color(0xFFE1DFFF),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Image.asset('assets/water_delivery.jpg'),
//             ),
//             SizedBox(height: 5),
//             Text(text, textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // class CategoryCard extends StatelessWidget {
// //   const CategoryCard({
// //     Key key,
// //     this.icon,
// //     this.text,
// //     this.press,
// //   }) : super(key: key);
// //
// //   final String icon, text;
// //   final GestureTapCallback press;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: press,
// //       child: SizedBox(
// //
// //         width: getProportionateScreenWidth(320),
// //         child: Container(
// //           decoration: BoxDecoration(
// //             // color: Color(0xFF4349FF),
// //             borderRadius: BorderRadius.circular(30),
// //             border: Border.all(color: Colors.blueAccent,width: .1)
// //           ),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Container(
// //                 padding: EdgeInsets.all(getProportionateScreenWidth(10)),
// //                 height: getProportionateScreenWidth(73),
// //                 width: getProportionateScreenWidth(65),
// //                 decoration: BoxDecoration(
// //                   // color: Color(0xFFFFECDF),
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 child: Image.asset('assets/water_delivery.jpg'),
// //                 // child: SvgPicture.asset(icon,color: Colors.white,),
// //               ),
// //               SizedBox(height: 5),
// //               Text(text, textAlign: TextAlign.center,style: TextStyle(color:Colors.blueAccent,fontSize: 22),),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

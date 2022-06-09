import 'package:flutter/material.dart';
import 'package:hammad_customer_0/constants.dart';

import '../../models/CustomerCoupon.dart';
import '../../services/Gen_database.dart';

class CouponCard extends StatelessWidget {
  const CouponCard({
    Key key,
    this.coupon,
    this.press,
  }) : super(key: key);

  final Function press;
  final CustomerCoupon coupon;

  @override
  Widget build(BuildContext context) {
    return BuildCouponCard(
      cid: coupon.couponId,
    );
  }
}

class BuildCouponCard extends StatelessWidget {
  final String cid;

  const BuildCouponCard({
    Key key,
    this.cid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: GenDatabaseService(context).getCouponStream(cid),
        builder: (context, snapshot) {
          return Container(
            color: Colors.black26,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 144,
                  width: 120,
                  child: Image.asset(
                    "assets/images/water_bottle_1.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.teal,
                  child: Stack(
                      children: [
                        Column(
                          children: [
                            Text('The Enchanted Nightingale'),
                            Text('Music by Julie Gable.'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('BUY TICKETS'),
                                  onPressed: () {
                                    /* ... */
                                  },
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('LISTEN'),
                                  onPressed: () {
                                    /* ... */
                                  },
                                ),
                                const SizedBox(width: 8),

                              ],
                            ),
                            Positioned(
                              right: 0,

                              child: Text('Music by Julie Gable.'),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
              ],
            ),
          );
        });
  }
}





//
//
//
//
//
//
//     GestureDetector(
//       onTap: (press),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Card(
//                       child:Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Expanded(
//                   child: Row(
//                     children: [
//                       SizedBox(
//                           height: 100,
//                           width: 100,
//                           child:Image(image: AssetImage("assets/images/water_bottle_1.jpg")),),
//                               SizedBox(width: 10),
//                       Column(
//                         children: [
//                           Text('${coupon.title}'),
//                          Text('${coupon.price}JOD'),
//
//                         ],
//                       ),
//                       SizedBox(height: 10,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           TextButton(
//                               child: const Text('BUY COUPON'),
//                                  onPressed: () {/* ... */},
//                           ),
//                           const SizedBox(width: 8),
//                           TextButton(
//                                child: const Text('DETAILS'),
//                                 onPressed: () {/* ... */},
//                           ),
//                           // const SizedBox(width: 8),
//                           //              Text(
//                           //       "${coupon.title}",
//                           //     style: Theme.of(context).textTheme.headline4,
//                           //       // fontWeight: FontWeight.w200,
//                           //     maxLines: 2,
//                           //   ),
//                           //   SizedBox(height: 5,),
//                           //   Text(
//                           //     "${coupon.price}JOD",
//                           //     style: Theme.of(context).textTheme.headline4,
//                           //       ),
//                           //   SizedBox(height: 5,),
//                           //   SizedBox(
//                           //     width: 80,
//                           //     child: ElevatedButton(
//                           //       style: ElevatedButton.styleFrom(primary: Colors.green),
//                           //       onPressed: () => null,
//                           //       child: Padding(
//                           //         padding: const EdgeInsets.all(4.0),
//                           //         child: Row(
//                           //           children: [
//                           //             Icon(Icons.touch_app),
//                           //             Text('Order'),
//                           //           ],
//                           //         ), //Row
//                           //       ), //Padding
//                           //     ), //RaisedButton
//                           //   ) //SizedBox
//                           ],
//     ),
//                     ],
//                   ),
//                 ),),),
//         ),);
//
//       // Column(
//       //   crossAxisAlignment: CrossAxisAlignment.center,
//       //   children: [
//       //     // AspectRatio(
//       //     //   aspectRatio: aspectRetio,
//       //     //   child: Container(
//       //     //     padding: EdgeInsets.all(getProportionateScreenWidth(5)),
//       //     //     decoration: BoxDecoration(
//       //     //       color: kSecondaryColor.withOpacity(0.05),
//       //     //       borderRadius: BorderRadius.circular(15),
//       //     //     ),
//       //     //     // padding: EdgeInsets.all(getProportionateScreenWidth(20)),
//       //     //     // decoration: BoxDecoration(
//       //     //     //   color: kSecondaryColor.withOpacity(0.05),
//       //     //     //   borderRadius: BorderRadius.circular(15),
//       //     //     // ),
//       //     //     child: Image.network("${coupon.image}",),
//       //     //   ),
//       //     // ),
//
//
//
//
//   }
// }
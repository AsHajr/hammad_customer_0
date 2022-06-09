
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hammad_customer_0/address/GoogleMapPage.dart';

import '../size_config.dart';

SizedBox buildMap(BuildContext context, LatLng cameraPosition){

  return SizedBox(
    height: getProportionateScreenHeight(105),
    width: getProportionateScreenWidth(300),
    child: Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Container(
            height: getProportionateScreenHeight(90),
            child: Stack(
                children: [
                  AbsorbPointer(
                      absorbing: true,
                      child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: cameraPosition, zoom: 15),
                          zoomControlsEnabled: false,
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(() => ScaleGestureRecognizer()),
                          }
                      )
                  ),
                  Positioned(
                      top: FractionalOffset.center.y - getProportionateScreenHeight(45),
                      bottom: FractionalOffset.center.y,
                      right: FractionalOffset.center.y,
                      left: FractionalOffset.center.y,

                      child:Icon(Icons.location_on,color: Colors.red,size: 40,)),
                ])
        ),
        Positioned(
          right: -16,
          bottom: -16,
          child: SizedBox(
            height: 46,
            width: 46,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                primary: Colors.white,
                backgroundColor: Color(0xFFF5F6F9),
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GoogleMapPage()));
              },
              child: Icon(Icons.edit,color: CupertinoColors.black,),
            ),
          ),
        )
      ],
    ),
  );
}

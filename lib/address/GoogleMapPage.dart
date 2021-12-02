
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hammad_customer_0/address/EditAddress.dart';
import 'package:hammad_customer_0/components/default_button.dart';
import 'package:hammad_customer_0/models/AddressModel.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:location/location.dart';

import 'package:hammad_customer_0/translations/locale_keys.g.dart';


class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  LatLng _initialcameraposition = LatLng(31.9539, 35.9106);
  GoogleMapController _controller;
  LatLng cameraPosition;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _currentLocation();
  }
void animateCamera(LocationData locationData) {
  _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(locationData.latitude, locationData.longitude),
          zoom: 18.0,),
      ));
}

  @override
  Widget build(BuildContext context) {
    final textDirection = getTextDir(context);
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black,),
          title: Text(LocaleKeys.delivery_location.tr(),
            style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: _initialcameraposition, zoom: 15),
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  // markers: Set.from(myMarker),
                  onCameraMove: (location) {
                    setState(() {
                      cameraPosition = location.target;
                    });
                  },
                  // onTap: _handleTap,
                ),
                Positioned(
                    top: FractionalOffset.center.y -
                        getProportionateScreenHeight(45),
                    bottom: FractionalOffset.center.y,
                    right: FractionalOffset.center.y,
                    left: FractionalOffset.center.y,

                    child:
                    Icon(Icons.location_on, color: Colors.red, size: 40,
                    )
                ),
                Positioned(
                  bottom: 140,
                  right: 15,
                  child: FloatingActionButton(

                    backgroundColor: Colors.white,
                    child: Icon(Icons.my_location, color: Colors.black54,),
                    onPressed: _currentLocation,
                  ),
                ),
                Positioned(
                    bottom: 30,
                    left: 27,
                    right: 27,
                    child: DefaultButton(
                      text: LocaleKeys.confirm.tr(),
                      press: () {
                      AddressModel address = new AddressModel(
                          '',
                          '',
                          cameraPosition,
                          '',
                          '',
                          '',
                          '',
                          '',
                          '');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              EditAddress(address: address,)));
                    },)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _currentLocation() async {
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }
    animateCamera(currentLocation);
  }
}

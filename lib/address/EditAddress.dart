import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:hammad_customer_0/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../components/Map.dart';
import '../components/default_button.dart';
import '../constants.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import '../models/AddressModel.dart';
import '../models/UserModel.dart';

class EditAddress extends StatefulWidget {
  final AddressModel address;

  const EditAddress({Key key, this.address}) : super(key: key);
  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {

  final _formKey = GlobalKey<FormState>();

  final areaCont = TextEditingController();

  final streetCont = TextEditingController();

  final nickNameCont = TextEditingController();

  final cityCont = TextEditingController();

  final buildingNoCont = TextEditingController();

  final floorCont = TextEditingController();

  final additionalDirCont = TextEditingController();

  AddressModel address;
  bool _isEdit;

  void getUserLocation(LatLng latLng) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude);
    setState(() {
      streetCont.text = placeMarks.first.street;
      areaCont.text = placeMarks.first.subLocality;
      cityCont.text = placeMarks.first.locality;
    });

  }
  @override
  void initState() {
    super.initState();
    address = widget.address;
    if(address.buildingNo.isEmpty){
      _isEdit = false;
      getUserLocation(address.latLng);
    }else{
      _isEdit = true;
      nickNameCont.text = address.nickName;
      areaCont.text = address.area;
      streetCont.text = address.street;
      buildingNoCont.text = address.buildingNo;
      floorCont.text = address.floor;
      additionalDirCont.text = address.additionalDirec;
      cityCont.text = address.city;

    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context,listen: false);
    SizeConfig().init(context);
    final textDirection = getTextDir(context);
    return Directionality(textDirection: textDirection, child:Scaffold(
      appBar: AppBar(
          title: _isEdit ? Text(LocaleKeys.edit_address.tr()) : Text(LocaleKeys.add_address.tr()),
          actions: [
            _isEdit ? TextButton(onPressed: () {
              DatabaseService(context).deleteAddress(user.id,address.id);
              Navigator.pop(context);
            },
                child: Text(LocaleKeys.delete.tr(),
                  style: TextStyle(color: Colors.black45, fontSize: 16),
                )
            ) : Text(''),
          ]),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildMap(context, widget.address.latLng),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildNickNameField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildCityField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildAreaFormField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildStreetField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildBuildingNumberFormField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildFloorFormField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildAdditionalDirectionsFormField(),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    _isEdit ? DefaultButton(
                      text: LocaleKeys.update_address.tr(),
                      press: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          final mAddress = AddressModel(address.id, nickNameCont.text.trim(),address.latLng, cityCont.text, areaCont.text.trim(), streetCont.text.trim(), buildingNoCont.text.trim(), floorCont.text.trim(), additionalDirCont.text.trim());
                            DatabaseService(context).updateAddress(user.id, mAddress);
                          Navigator.pop(context);
                        }
                      },
                    ):DefaultButton(
                      text: LocaleKeys.save_address.tr(),
                      press: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          final mAddress = AddressModel(
                              '',
                              nickNameCont.text.trim(),
                              address.latLng,
                              cityCont.text,
                              areaCont.text.trim(),
                              streetCont.text.trim(),
                              buildingNoCont.text.trim(),
                              floorCont.text.trim(),
                              additionalDirCont.text.trim());
                          DatabaseService(context).writeNewAddress(
                              user.id, mAddress);
                          Navigator.pop(context);
                        }
                      }
                    ),
                    SizedBox(height: getProportionateScreenWidth(20),)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildNickNameField() {
    return TextFormField(
      autofocus: true,
      controller: nickNameCont,
      decoration: InputDecoration(
        labelText: LocaleKeys.nick_name.tr(),
        hintText: LocaleKeys.example_home.tr(),
      ),
    );
  }
  TextFormField buildCityField() {
    return TextFormField(
      enabled: false,
      controller: cityCont,
      validator: (val) =>
      val.isEmpty ? kRequired
          : null,
      decoration: InputDecoration(
        labelText: LocaleKeys.city.tr(),
      ),
    );
  }
  TextFormField buildAreaFormField() {
    return TextFormField(
      controller: areaCont,
      validator: (val) =>
      val.isEmpty ? kRequired
          : null,
      decoration: InputDecoration(
        labelText: LocaleKeys.area.tr(),
      ),
    );
  }

  TextFormField buildStreetField() {
    return TextFormField(
      controller: streetCont,
      validator: (val) =>
      val.isEmpty ? kRequired
          : null,
      decoration: InputDecoration(
        labelText: LocaleKeys.street.tr(),
      ),
    );
  }

  TextFormField buildBuildingNumberFormField() {
    return TextFormField(
      controller: buildingNoCont,
      keyboardType: TextInputType.number,
      validator: (val) =>
      val.isEmpty ? kRequired
          : null,
      decoration: InputDecoration(
        labelText: LocaleKeys.building_number.tr(),
      ),
    );
  }

  TextFormField buildFloorFormField() {
    return TextFormField(
      controller: floorCont,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: LocaleKeys.floor.tr(),
        hintText: LocaleKeys.optional.tr(),
      ),
    );
  }

  TextFormField buildAdditionalDirectionsFormField() {
    return TextFormField(
      controller: additionalDirCont,
      decoration: InputDecoration(
        labelText: LocaleKeys.additional_directions.tr(),
        hintText: LocaleKeys.optional.tr(),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    nickNameCont.dispose();
    areaCont.dispose();
    streetCont.dispose();
    buildingNoCont.dispose();
    floorCont.dispose();
    additionalDirCont.dispose();
    cityCont.dispose();
  }
}

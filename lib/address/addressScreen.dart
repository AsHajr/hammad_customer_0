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

import '../components/FormTextField.dart';
import '../components/map.dart';
import '../components/default_button.dart';
import '../constants.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import '../models/Address.dart';
import '../models/user_model.dart';


class AddressScreen extends StatefulWidget {
  final Address address;
  const AddressScreen({Key key, this.address}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  Address address;
  bool _isEditing;


  @override
  void initState() {
    super.initState();
    address = widget.address;
    address.buildingNo.isEmpty ? _isEditing = true : _isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false);
    SizeConfig().init(context);
    final textDirection = getTextDir(context);
    return Directionality(textDirection: textDirection, child: Scaffold(
      appBar: AppBar(
          title: _isEditing ? Text(LocaleKeys.edit_address.tr()) : Text(
              LocaleKeys.add_address.tr()),
          actions: [
            _isEditing ? TextButton(onPressed: () {
              _showDeleteDialog(user);
              Navigator.pop(context);
            },
                child: Text(LocaleKeys.delete.tr(),
                  style: TextStyle(color: Colors.black45, fontSize: 16),
                )
            ) : Text(''),
          ]),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildMap(context, widget.address.latLng),
                SizedBox(height: getProportionateScreenHeight(10)),
                AddressForm(user: user, address: widget.address,),
                SizedBox(height: getProportionateScreenWidth(20),)
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Future<void> _showDeleteDialog(UserModel user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text("Delete Address"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Are you sure you want to delete this address"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.yes.tr(),style: TextStyle(color: kPrimaryColor),),
              onPressed: () async{
                DatabaseService(context, user.id).deleteAddress(address.id);
                Navigator.pop(context);
                },
            ),
            TextButton(
              child: Text(LocaleKeys.no.tr(),style: TextStyle(color: kPrimaryColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AddressForm extends StatefulWidget {
  final Address address;
  final UserModel user;
  AddressForm({Key key, this.address, this.user}) : super(key: key);

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing;
  Address address;
  final areaCont = TextEditingController();

  final streetCont = TextEditingController();

  final nickNameCont = TextEditingController();

  final cityCont = TextEditingController();

  final buildingNoCont = TextEditingController();

  final floorCont = TextEditingController();

  final additionalDirCont = TextEditingController();

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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          BuildTextField(
            labelText: LocaleKeys.nick_name.tr(),
            hintText: LocaleKeys.example_home.tr(),
            textEditingController: nickNameCont,
            autofocus: true,),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildTextField(
            labelText: LocaleKeys.city.tr(), textEditingController: cityCont,
            enabled: false,),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildTextField(
            labelText: LocaleKeys.area.tr(), textEditingController: areaCont,
            autofocus: true,),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildTextField(
            labelText: LocaleKeys.street.tr(),
            textEditingController: streetCont,
            isRequired: true,),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildTextField(
            labelText: LocaleKeys.building_number.tr(),
            textEditingController: streetCont,
            textInputType: TextInputType.number,
            isRequired: true,),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildTextField(
            labelText: LocaleKeys.floor.tr(),
            hintText: LocaleKeys.optional.tr(),
            textEditingController: floorCont,
            textInputType: TextInputType.number,),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildTextField(
            labelText: LocaleKeys.additional_directions.tr(),
            hintText: LocaleKeys.optional.tr(),
            textEditingController: additionalDirCont,),

          _isEditing ? DefaultButton(
            text: LocaleKeys.update_address.tr(),
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                final mAddress = Address(
                    widget.address.id,
                    nickNameCont.text.trim(),
                    widget.address.latLng,
                    cityCont.text,
                    areaCont.text.trim(),
                    streetCont.text.trim(),
                    buildingNoCont.text.trim(),
                    floorCont.text.trim(),
                    additionalDirCont.text.trim());
                DatabaseService(context, widget.user.id).updateAddress(
                    mAddress);
                Navigator.pop(context);
              }
            },
          ) : DefaultButton(
              text: LocaleKeys.save_address.tr(),
              press: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  final mAddress = Address(
                      '',
                      nickNameCont.text.trim(),
                      widget.address.latLng,
                      cityCont.text,
                      areaCont.text.trim(),
                      streetCont.text.trim(),
                      buildingNoCont.text.trim(),
                      floorCont.text.trim(),
                      additionalDirCont.text.trim());
                  DatabaseService(context, widget.user.id).writeNewAddress(
                      mAddress);
                  Navigator.pop(context);
                }
              }
          ),
          SizedBox(height: getProportionateScreenWidth(20),)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    address = widget.address;
    if (address.buildingNo.isEmpty) {
      _isEditing = false;
      getUserLocation(address.latLng);
    } else {
      _isEditing = true;
      nickNameCont.text = address.nickName;
      areaCont.text = address.area;
      streetCont.text = address.street;
      buildingNoCont.text = address.buildingNo;
      floorCont.text = address.floor;
      additionalDirCont.text = address.additionalDirec;
      cityCont.text = address.city;
    }
  }
}

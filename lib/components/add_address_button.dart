import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../address/GoogleMapPage.dart';

Padding addAddressButton(BuildContext context){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 60,
      child: TextButton.icon(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoogleMapPage()));
        },
        label: Text(LocaleKeys.add_address.tr(),
          style: TextStyle(color: Colors.black38),)
        , icon: Icon(Icons.add, color: Colors.black38,),),
    ),
  );
}
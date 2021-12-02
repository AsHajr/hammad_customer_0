
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/constants.dart';
import 'package:hammad_customer_0/services/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';

import '../../address/SavedAddresses.dart';
import 'ChangeLanguage.dart';
import 'ChangePhone.dart';
import 'MyAccount.dart';
import 'profile_menu.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isEnChecked = false;
  bool isArChecked = false;
  TextDirection textDirection;

  void checkLanguage(){
    if (context.locale == Locale('ar')){
      isArChecked = true;
      isEnChecked = false;
    }else{
      isEnChecked = true;
      isArChecked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLanguage();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
          children: [
            ProfileMenu(
              text: LocaleKeys.my_account.tr(),
              icon: Icons.person_outlined,
              press: () => {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  MyAccount()))
              },
            ),
            ProfileMenu(
              text: LocaleKeys.change_phone.tr(),
              icon: Icons.phone_outlined,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ChangePhone()));
                },
            ),
            ProfileMenu(
              text: LocaleKeys.saved_addresses.tr(),
              icon: Icons.location_on_outlined,
              press: () { Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SavedAddresses()));
              },
            ),
            ProfileMenu(
              text: LocaleKeys.language.tr(),
              icon: Icons.language,
              press: () {
                showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return ChangeLanguageDialog(isEnChecked: isEnChecked,isArChecked: isArChecked,);
                    });
              },
            ),
            ProfileMenu(
              text: LocaleKeys.sign_out.tr(),
              icon: Icons.logout,
              press: () {_showSignOutDialog();},
            ),
          ],
        ),
    );
  }
  Future<void> _showSignOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(LocaleKeys.sign_out.tr()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(LocaleKeys.are_you_sure_to_sign_out.tr()),
                // Text("You are going to have to login again."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.yes.tr(),style: TextStyle(color: kPrimaryColor),),
              onPressed: () async{
                await AuthService().signOut();
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

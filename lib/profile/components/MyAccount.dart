import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/components/default_button.dart';
import 'package:hammad_customer_0/constants.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../size_config.dart';

//Todo change to form error
class MyAccount extends StatefulWidget {
  const MyAccount({Key key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}


class _MyAccountState extends State<MyAccount> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCont = TextEditingController();
  final lastNameCont = TextEditingController();
  UserModel user;

  @override
  Widget build(BuildContext context) {
    final textDirection = getTextDir(context);
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.my_account.tr()),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildPhoneField(),
                  SizedBox(height: 10,),
                  buildFirstNameField(),
                  SizedBox(height: 10,),
                  buildLastNameField(),
                  SizedBox(height: getProportionateScreenHeight(10),),
                  DefaultButton(
                    text: LocaleKeys.save.tr(),
                    press: () {
                      if (_formKey.currentState.validate()) {
                        DatabaseService(context).updateUserName(user.id, firstNameCont.text, lastNameCont.text);
                        Navigator.pushReplacementNamed(context,'/');
                      }
                      //   _formKey.currentState.save();
                      // if all are valid then go to success screen
                      // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  TextFormField buildPhoneField() {
    return TextFormField(
      initialValue: user.phone,
      decoration: InputDecoration(
        labelText: LocaleKeys.phone.tr(),
        enabled: false,
      ),
    );
  }
  TextFormField buildFirstNameField() {
    return TextFormField(
      controller: firstNameCont,
      validator: (value) {
        if (value.isEmpty) {
          return kRequired;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: LocaleKeys.first_name.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
  TextFormField buildLastNameField() {
    return TextFormField(
      controller: lastNameCont,
      validator: (value) {
        if (value.isEmpty) {
          return kRequired;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: LocaleKeys.last_name.tr(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserModel>(context, listen: false);

    firstNameCont.text = user.firstName;
    lastNameCont.text = user.lastName;
  }

  @override
  void dispose() {
    firstNameCont.dispose();
    lastNameCont.dispose();
    super.dispose();
  }
}


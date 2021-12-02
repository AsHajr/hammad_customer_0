import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/components/custom_surfix_icon.dart';
import 'package:hammad_customer_0/components/default_button.dart';
import 'package:hammad_customer_0/components/form_error.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';


import '../../constants.dart';
import '../../size_config.dart';
import '../../wrapper.dart';



class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String lastName;
  String address;
  User user;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: LocaleKeys.continue_text.tr(),
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                UserModel mUser = new UserModel(user.uid, firstName,lastName, user.phoneNumber, '0');
                DatabaseService(context).signUpUser(mUser);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Wrapper()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: LocaleKeys.last_name.tr(),
        hintText: LocaleKeys.enter_your_last_name.tr(),
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: LocaleKeys.first_name.tr(),
        hintText: LocaleKeys.first_name.tr(),
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
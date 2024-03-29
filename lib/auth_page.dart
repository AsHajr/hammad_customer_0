
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/services/auth.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/otpStream.dart';
import 'package:hammad_customer_0/size_config.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'components/default_button.dart';
import 'components/form_error.dart';
import 'constants.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';




final AuthService _auth = AuthService();


class AuthPage extends StatefulWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}


class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final isSent = Provider.of<OtpStream>(context);
    if(isSent.otpSentValue){
      return OtpScreen();
    }
      return LoginScreen();
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final textDirection = getTextDir(context);
    return Directionality(
        textDirection: textDirection,
        child: Scaffold(
          appBar: AppBar(
          ),
          body: LoginBody(),
        )
    );
  }
}
class LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Text(
                    LocaleKeys.welcome_to_hammad.tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    LocaleKeys.sign_in_with_phone_number.tr(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  CompleteProfileForm(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  // TODO add terms and conditions
                  Text(LocaleKeys.terms_and_conditions.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String phoneNumber;
  String countryCode = '+962';

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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: LocaleKeys.continue_text.tr(),
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                _auth.verifyPhone(context, '$countryCode$phoneNumber');
              }
            },
          ),
        ],
      ),
    );
  }

  Row buildPhoneNumberFormField() {
    return Row(
        children: [
          CountryCodePicker(
            onChanged: (code) {
              setState(() {
                countryCode = '$code';
              });
            },
            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            initialSelection: 'JO',
            favorite: ['JO'],
            // optional. Shows only country name and flag
            showCountryOnly: false,
            // optional. Shows only country name and flag when popup is closed.
            showOnlyCountryWhenClosed: false,
            // optional. aligns the flag and the Text left
            alignLeft: false,
            showFlag: true,
            padding: EdgeInsets.zero,
          ),

          Container(
            height: 80,
            width: getProportionateScreenWidth(236),
            child: TextFormField(
              onFieldSubmitted: (value) {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _auth.verifyPhone(context, '$countryCode$phoneNumber');
                }
              },
              autofocus: false,
              keyboardType: TextInputType.phone,
              onSaved: (newValue) => phoneNumber = newValue,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kPhoneNumberNullError);
                }
                return null;
              },
              validator: (value) {
                if (value.isEmpty) {
                  addError(error: kPhoneNumberNullError);
                  return "";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: LocaleKeys.phone.tr(),
                hintText: LocaleKeys.enter_your_phone_number.tr(),
              ),
            ),
          ),
        ]
    );
  }
}
class OtpScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final textDirection = getTextDir(context);
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.otp_verification.tr()),
        ),
        body: OtpBody(phone: _auth.myPhone,),
      ),
    );
  }
}
class OtpBody extends StatefulWidget {
  final String phone;
  const OtpBody({Key key,this.phone}) : super(key: key);
  @override
  _OtpBodyState createState() => _OtpBodyState();
}

class _OtpBodyState extends State<OtpBody> {
  bool timerEnd = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                LocaleKeys.otp_verification.tr(),
                style: headingStyle,
              ),
              Text("${LocaleKeys.we_sent_code_to.tr()} ${widget.phone}"),
              !timerEnd ?  buildTimer() : GestureDetector(
                onTap: (){
                  _auth.verifyPhone(context, widget.phone);
                },
                child: Text(
                    LocaleKeys.resend_otp_code.tr(),
                    style: TextStyle(decoration: TextDecoration.underline)),
              ),
              OtpForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(LocaleKeys.resend_code_in.tr()),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: Duration(seconds: 30),
          onEnd:(){
            setState(() {
              timerEnd = true;
            });
          },
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}

class OtpForm extends StatefulWidget {
  const OtpForm({
    Key key,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String code;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          PinEntryTextField(
            fields: 6,
            onSubmit: (String pin) {
              code = pin;
              _auth.verifySMS(context, pin);
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: LocaleKeys.continue_text.tr(),
            press: () {
              AuthService().verifySMS(context, code);
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/components/default_button.dart';
import 'package:hammad_customer_0/services/AuthState.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';


import 'package:provider/provider.dart';

import '../../constants.dart';





class ChangePhone extends StatefulWidget {
  const ChangePhone({Key key}) : super(key: key);

  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  final _formKey = GlobalKey<FormState>();
  String phone;

  @override
  Widget build(BuildContext context) {
    final textDirection = getTextDir(context);
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.change_phone.tr()),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildPhoneField(),
                SizedBox(height: 25,),
                DefaultButton(
                  text: LocaleKeys.submit.tr(),
                  press: () {
                      _showSignOutDialog();
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  TextFormField buildPhoneField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: LocaleKeys.phone.tr(),
      ),
    );
  }
  Future<void> _showSignOutDialog() async {
    final isUpdating = Provider.of<AuthUpdating>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(LocaleKeys.change_phone.tr()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(LocaleKeys.are_you_sure_to_change_phone.tr()),
                // Text("You are going to have to login again."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.yes.tr(),style: TextStyle(color: kPrimaryColor),),
              onPressed: () async{
                isUpdating.changeToTrue();
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
// class OtpUpdatePhone extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     // Map data = ModalRoute
//     //     .of(context)
//     //     .settings
//     //     .arguments as Map;
//     SizeConfig().init(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("OTP Verification"),
//       ),
//       body: otpBody(phone: _mauth.myPhone,),
//     );
//   }
// }
// class otpBody extends StatefulWidget {
//   final String phone;
//   const otpBody({Key key,this.phone}) : super(key: key);
//   @override
//   _otpBodyState createState() => _otpBodyState();
// }
//
// class _otpBodyState extends State<otpBody> {
//   bool timerEnd = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Padding(
//         padding:
//         EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: SizeConfig.screenHeight * 0.05),
//               Text(
//                 "OTP Verification",
//                 style: headingStyle,
//               ),
//               Text("We sent your code to ${widget.phone}"),
//               !timerEnd ?  buildTimer() : GestureDetector(
//                 onTap: (){
//                   _mauth.verifyPhone(context, widget.phone);
//                 },
//                 child: Text(
//                     "Resend OTP Code",
//                     style: TextStyle(decoration: TextDecoration.underline)),
//               ),
//               OtpForm(),
//               SizedBox(height: SizeConfig.screenHeight * 0.1),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Row buildTimer() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text("Resend code in "),
//         TweenAnimationBuilder(
//           tween: Tween(begin: 30.0, end: 0.0),
//           duration: Duration(seconds: 30),
//           onEnd:(){
//             setState(() {
//               timerEnd = true;
//             });
//           },
//           builder: (_, dynamic value, child) => Text(
//             "00:${value.toInt()}",
//             style: TextStyle(color: kPrimaryColor),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class OtpForm extends StatefulWidget {
//   const OtpForm({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   _OtpFormState createState() => _OtpFormState();
// }
//
// class _OtpFormState extends State<OtpForm> {
//   String code;
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: Column(
//         children: [
//           SizedBox(height: SizeConfig.screenHeight * 0.15),
//           PinEntryTextField(
//             fields: 6,
//             onSubmit: (String pin) {
//               code = pin;
//               _mauth.verifySMS(context, pin);
//             },
//           ),
//           SizedBox(height: SizeConfig.screenHeight * 0.15),
//           DefaultButton(
//             text: "Continue",
//             press: () {
//               // AuthService().verifySMS(context, code);
//               //Todo remove
//               // Navigator.pushReplacement(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => SignUpScreen()),
//               // );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
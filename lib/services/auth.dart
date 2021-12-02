
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/constants.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:hammad_customer_0/sign_up/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../AuthPage.dart';
import '../wrapper.dart';
import 'AuthState.dart';
import 'database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  ProgressDialog pd;
  String myVerificationId = "";
  PhoneAuthCredential credential;
  String myPhone;
  bool _isLogged = false;

  Stream<User> get user => _auth.userChanges();


  // sign in with phone
  Future verifyPhone(BuildContext context, String phone) async {
    FocusScope.of(context).unfocus();
    pd = ProgressDialog(context: context);
    pd.show(max: 60, msg: LocaleKeys.sending_sms.tr(),progressBgColor: kPrimaryLightColor,progressValueColor: kPrimaryColor);
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential mCredential) async {
          credential = mCredential;
          //TODO check if current page is Otp to pop
          _isLogged = true;
          pd.close();
          await signInOrUpdate(context);
          navigateToSignUP(context);
        },
        verificationFailed: (FirebaseAuthException e) async {
          pd.close();
          if (e.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        LocaleKeys.the_provided_phone_number_is_invalid.tr())));
          }
        },
        codeSent: (String verificationId, int resendToken) async {
          myVerificationId = verificationId;
          myPhone = phone;
          if(_isLogged = false){
          navigate(context, OtpScreen());
          }
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
      return FirebaseAuth.instance.currentUser;
    }
    catch (e) {
      pd.close();
      print(e.toString());
      return null;
    }
  }

  void verifySMS(BuildContext context, String code) async {
    pd = ProgressDialog(context: context);
    pd.show(max: 60, msg: LocaleKeys.verifying_phone.tr(),progressBgColor: kPrimaryLightColor,progressValueColor: kPrimaryColor);
    try {
      credential = PhoneAuthProvider.credential(
          verificationId: myVerificationId, smsCode: code);
      // Sign the user in (or link) with the credential
      await signInOrUpdate(context);
      navigateToSignUP(context);
    }
    catch (e) {
      pd.close();
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(LocaleKeys.verification_code_is_invalid.tr())));
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signInOrUpdate(BuildContext context) async {
    final isUpdating = Provider.of<AuthUpdating>(context, listen: false);

    if (isUpdating.isUpdatingValue) {
      await _auth.currentUser.updatePhoneNumber(credential);
      isUpdating.changeToFalse();
      final user = _auth.currentUser;
      DatabaseService(context).updateUserPhone(user.uid, user.phoneNumber);
    } else {
      await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  navigate(BuildContext context, Widget page) {
    FocusScope.of(context).unfocus();
    pd.close();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  void navigateToSignUP(BuildContext context){
    final isUpdating = Provider.of<AuthUpdating>(context, listen: false);
    if (isUpdating.isUpdatingValue ){
      navigate(context, Wrapper());
    }else{
      navigate(context, SignUpScreen());
    }
  }
}

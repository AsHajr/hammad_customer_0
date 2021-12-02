
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;

import '../size_config.dart';

bool getLang(BuildContext context){
  bool isAr;
  if (context.locale == Locale('ar')){
    isAr = true;
  }else{
    isAr = false;
  }
  return isAr;
}
TextDirection getTextDir(BuildContext context){

  TextDirection textDirection;
  if (context.locale == Locale('ar')){
    textDirection = TextDirection.rtl;
  }else{
    textDirection = TextDirection.ltr;
  }
  return textDirection;
}
EdgeInsetsGeometry getPaddingDir(BuildContext context){
  EdgeInsetsGeometry padding;
  if (context.locale == Locale('ar')){
    padding = EdgeInsets.only(right: getProportionateScreenWidth(15),left: getProportionateScreenWidth(2));
  }else{
    padding = EdgeInsets.only(left: getProportionateScreenWidth(15),right: getProportionateScreenWidth(2));
  }
  return padding;
}
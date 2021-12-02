
import 'package:flutter/cupertino.dart';

class OfferModel{
  String id;
  String title;
  String startDate;
  String expiryDate;
  String points;
  String imageUrl;
  BoxFit boxFit;
  String description;
  String subDescription;

  OfferModel(this.id, this.title, this.startDate, this.expiryDate, this.points,this.imageUrl,this.boxFit,this.description,this.subDescription);

  // factory OfferModel.toModel(Map<String, dynamic> data){
  //   return OfferModel(data['title'], data['start date'], data['expiry date']);
  // }
}
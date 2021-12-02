
import 'dart:async';


import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hammad_customer_0/constants.dart';
import 'package:hammad_customer_0/models/cartItem.dart';
import 'package:hammad_customer_0/models/productModel.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import 'package:hammad_customer_0/models/AddressModel.dart';
import 'package:hammad_customer_0/models/OfferModel.dart';
import 'package:hammad_customer_0/models/OrderModel.dart';
import 'package:hammad_customer_0/models/RedeemOffers.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:easy_localization/easy_localization.dart';



class DatabaseService {

  BuildContext context;

  DatabaseService(this.context);

  final DatabaseReference reference = FirebaseDatabase.instance.reference();

  Future<void> signUpUser(UserModel user) async{
    reference.child('users').child(user.id).once().then((value){
      if(value.value != null){
        updateUserName(user.id,user.firstName,user.lastName);
      }else{
        writeNewUser(user);
      }
    });
    String fcmToken = await FirebaseMessaging.instance.getToken();
    reference.child('users').child(user.id).update(<String, String>{
      "fcmToken": fcmToken
    });
  }
  Future<bool> checkUserExistence(UserModel user)async{
    bool exist;
    await FirebaseDatabase.instance.reference().child('users').orderByChild("phone").equalTo(user.id)
        .once()
        .then((value) async {
      if (value.value != null) {
        exist = true;
      }else{
        exist = false;
      }
        });
        return exist;
  }
  Future<void> writeNewUser(UserModel user) async{
    await FirebaseDatabase.instance.reference().child('users').orderByChild("phone").equalTo(user.phone)
        .once()
        .then((value) async {
      if (value.value != null) {
        final _user = new Map<String, dynamic>.from(value.value).entries
            .map((e) {
          return UserModel(
              e.key, e.value['first_name'],e.value['last_name'], e.value['phone'], e.value['points']);
        }).toList();
        final points = _user.first.points;
        deleteUser(_user.first.id);
        try {
          user.points = points;
        } catch (e) {}
      }
      try {
        await reference.child('users').child(user.id).update(<String, Object>{
          'first_name': user.firstName,
          'last_name':user.lastName,
          'phone': user.phone,
          'points': user.points,
        });
      } catch (e) {
        _showSnackBar(kFailed);
      }
    });
  }
  Future updateUserName(String uid, String firstName, String lastName) async {
    try {
      await FirebaseDatabase.instance.reference().child('users')
          .child(uid)
          .update(<String, Object>{
        'first_name': firstName,
        'last_name': lastName,
      });
    } catch (e) {}
  }
  //TODO add snack bars on admin only
  Future updateUserPhone(String uid, String phone) async{
     try{
       await FirebaseDatabase.instance.reference().child('users').child(uid).update(<String, Object>{
         'phone' : phone,
       });
     }catch(e){
       _showSnackBar(kFailed);
     }
  }
  Future updateUserPoints(String uid, String points) async{
    try{
    await FirebaseDatabase.instance.reference().child('users').child(uid).update(<String, Object>{
      'points' : points,
    });
    }catch(e){
      _showSnackBar(kFailed);
    }
  }
  Future deleteUser(String uid) async{
    try {
      await reference.child('users').child(uid).remove();
    }catch(e){
      _showSnackBar(kFailed);
    }
  }

  Future writeNewAddress(String uid ,AddressModel address) async{
    try{
      await reference.child('users').child(uid).child('addresses').push().set(<String, Object>{
        'nick_name': address.nickName,
        'location':{
          'latitude': address.latLng.latitude,
          'longitude':address.latLng.longitude,
        },
        'city' : address.city,
        'area': address.area,
        'street': address.street,
        'building_number': address.buildingNo,
        'floor': address.floor,
        'additional_directions': address.additionalDirec,
      });
    }catch(e){
      _showSnackBar(kFailed);
    }
  }



  Future updateAddress(String uid ,AddressModel address) async{
    try{
      await reference.child('users').child(uid).child('addresses').child(address.id).update(<String, Object>{
        'nick_name': address.nickName,
        'location':{
          'latitude': address.latLng.latitude,
          'longitude':address.latLng.longitude,
        },
        'city' : address.city,
        'area': address.area,
        'street': address.street,
        'building_number': address.buildingNo,
        'floor': address.floor,
        'additional_directions': address.additionalDirec,
      });
      _showSnackBar(LocaleKeys.address_updated_successfully.tr());
    }catch(e){
      //TODO change to something went wrong
      _showSnackBar(kFailed);
    }
  }
  Future writeNewOrder(OrderModel order) async{
    final Map cart = Map.fromIterable(order.cart,key: (e)=> e.id,value: (e)=> e.quantity);
    try{
      await reference.child('orders').push().set(<String, Object>{
        'customer_id' : order.customerId,
        'address_id': order.addressId,
        'notes': order.notes,
        'timestamp': '${DateTime.now()}',
        'delivered_at': '',
        'products': cart,
        'price': order.price,
        'status': 'pending',
        'service': order.service,
      });
      _showSnackBar(LocaleKeys.order_placed_successfully.tr());
    }catch(e){
      _showSnackBar(kFailed);
    }
  }
  Stream<List<AddressModel>> getAddressesStream(String uid) {
    return reference
        .child('users').child(uid).child('addresses')
        .onValue
        .map((e) {
      return Map<String, dynamic>.from(e.snapshot.value).entries.map((e) {
        Map location = e.value['location'];
        return AddressModel(
            e.key,
            e.value['nick_name'],
            LatLng(location['latitude'],location['longitude']),
            e.value['city'],
            e.value['area'],
            e.value['street'],
            e.value['building_number'],
            e.value['floor'],
            e.value['additional_directions']);
      }).toList();
    });
  }
  Stream<AddressModel> getAddressStream(String uid, String adrsId) {
    return reference
        .child('users').child(uid).child('addresses').child(adrsId)
        .onValue
        .map((e) {
      Map location = e.snapshot.value['location'];
      return AddressModel(
          e.snapshot.key,
          e.snapshot.value['nick_name'],
          LatLng(location['latitude'],location['longitude']),
          e.snapshot.value['city'],
          e.snapshot.value['area'],
          e.snapshot.value['street'],
          e.snapshot.value['building_number'],
          e.snapshot.value['floor'],
          e.snapshot.value['additional_directions']);
    });
  }
  Future deleteAddress(String uid, String aid) async{
    try {
      await reference.child('users').child(uid).child('addresses').child(aid).remove();
    }catch(e){
      _showSnackBar(kFailed);
    }
  }
  Future writeRedeemedOffer(UserModel user, RedeemedOffers offer, String offerPoints) async{
    try{
      final points =  int.parse(user.points) - int.parse(offerPoints);
      await updateUserPoints(user.id, '$points');
      await FirebaseDatabase.instance.reference().child('users').child(user.id).child('offers').push().set(<String, Object>{
        'offer_id' : offer.offerId,
        'timestamp' : '${DateTime.now()}',
        'status' : offer.status,
      });
    }catch(e){
      _showSnackBar(kFailed);
    }
  }
  Stream<List<OfferModel>> get getOffersStream {
    return reference.child('offers').onValue.map((e){
      return Map<String, dynamic>.from(e.snapshot.value).entries.map((e) {
        BoxFit boxFit;
        switch(e.value['box_fit']) {
          case 'cover': {
            // statements;
            boxFit = BoxFit.cover;
          }
          break;

          case 'fill': {
            //statements;
            boxFit = BoxFit.fill;
          }
          break;

          default: {
            //statements;
            boxFit = BoxFit.cover;
          }
          break;
        }
        return OfferModel(e.key,e.value['title'], e.value['start_date'],
            e.value['end_date'], e.value['points'],e.value['photo_url'],boxFit,e.value['description'],e.value['sub_description']);
      }).toList();
    });
  }
  Stream<OfferModel> getOfferStream(String id){
    return FirebaseDatabase.instance.reference().child('offers').child(id).onValue.map((e) {
      BoxFit boxFit;
      switch(e.snapshot.value['box_fit']) {
        case 'cover': {
          // statements;
          boxFit = BoxFit.cover;
        }
        break;

        case 'fill': {
          //statements;
          boxFit = BoxFit.fill;
        }
        break;

        default: {
          //statements;
          boxFit = BoxFit.cover;
        }
        break;
      }
      return OfferModel(e.snapshot.key, e.snapshot.value['title'],
          e.snapshot.value['start_date'],e.snapshot.value['end_date'], e.snapshot.value['points'],
          e.snapshot.value["photo_url"],boxFit,e.snapshot.value['description'],e.snapshot.value['sub_description']);
    });
  }
  Stream<List<RedeemedOffers>> getWaitingOffersStream(String uid) {
    return reference.child('users').child(uid).child('offers').orderByChild('status').equalTo('waiting').onValue.map((e){
      return Map<String, dynamic>.from(e.snapshot.value).entries.map((e) {
        return RedeemedOffers(e.key,e.value['offer_id'], e.value['status']);
      }).toList();
    });
  }
  Stream<List<OrderModel>> getOrdersStream(uid) {
    return reference.child('orders').orderByChild('customer_id').equalTo(uid).limitToLast(5).onValue.map((e){
      return Map<String, dynamic>.from(e.snapshot.value).entries.map((e) {
          List<CartItem> products = Map<String, dynamic>.from(e.value['products']).entries.map((m) => CartItem(m.key, m.value)).toList();
          return OrderModel(e.key,e.value['customer_id'], e.value['address_id'],
              products, e.value['price'],e.value['notes'],e.value['status'],e.value['delivered_at'],e.value['service']);
        }).toList();
    });
  }
  Stream<List<OrderModel>> getAllDeliveredOrdersStream(uid) {
    return reference.child('orders').orderByChild('customer_id').equalTo(uid).onValue.map((e){
      return Map<String, dynamic>.from(e.snapshot.value).entries.map((e) {
          List<CartItem> products = Map<String, dynamic>.from(e.value['products']).entries.map((m) => CartItem(m.key, m.value)).toList();
          return OrderModel(e.key,e.value['customer_id'], e.value['address_id'],
              products, e.value['price'],e.value['notes'],e.value['status'],e.value['delivered_at'],e.value['service']);
        }).toList();
    });
  }
  Stream<List<Product>> get getProductsStream {
    return reference.child('products').onValue.map((e){
      return Map<String, dynamic>.from(e.snapshot.value).entries.map((e) {
        return Product(e.key,e.value['title'], e.value['price'],e.value['image_url']);
      }).toList();
    });
  }
  Stream<Product> getProductStream(String id) {
    return reference.child('products').child(id).onValue.map((e){
      return Product(e.snapshot.key,e.snapshot.value['title'], e.snapshot.value['price'],e.snapshot.value['image_url']);
    });
  }
  void _showSnackBar(String mesg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(mesg)));
  }
}
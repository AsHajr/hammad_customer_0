
import 'cartItem.dart';

class OrderModel{
  String id;
  String customerId;
  String addressId;
  String notes;
  int timeStamp;
  String status;
  String deliveredAt;
  List<CartItem> cart;
  String price;
  String service;

  OrderModel(this.id, this.customerId, this.addressId, this.cart, this.price, this.notes, this.status,this.deliveredAt,this.service);

}
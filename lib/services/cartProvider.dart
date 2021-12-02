import 'package:flutter/cupertino.dart';
import 'package:hammad_customer_0/models/cartItem.dart';

class CartProvider extends ChangeNotifier{
   List<CartItem> cart = [];
   double cartPrice = 0;

   List<CartItem> get cartValue => cart;
   double get priceValue => double.parse(cartPrice.toStringAsFixed(2));

   void addToCart(CartItem cartItem, double price){
      cart.add(cartItem);
      addToPrice(price);
      notifyListeners();
   }
   void removeFromCart(int index){
      cart.removeAt(index);
      notifyListeners();
   }
   void  addToPrice(double price){
      cartPrice += (price);
   }
}
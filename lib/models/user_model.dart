
import 'package:hammad_customer_0/models/Address.dart';

class UserModel {
  String id;
  String firstName;
  String lastName;
  String phone;
  String points;
  List<Address> addresses;
  String orders;

  UserModel(this.id, this.firstName, this.lastName, this.phone, this.points);


  // factory UserModel.toModel(Map<String, dynamic> data){
  //   return UserModel(data[],data['name'], data['phone'], data['points']);
  // }

}
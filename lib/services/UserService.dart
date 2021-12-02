import 'package:firebase_database/firebase_database.dart';
import 'package:hammad_customer_0/models/UserModel.dart';

class UserService{

  String uid;
  final DatabaseReference reference = FirebaseDatabase.instance.reference();


  UserService(this.uid);


  Stream<UserModel> get getUserStream{
    return reference.child('users').child(uid).onValue.map((e) {
      return UserModel(e.snapshot.key, e.snapshot.value['first_name'],e.snapshot.value['last_name'],e.snapshot.value['phone'],e.snapshot.value['points']);
    });
  }

}
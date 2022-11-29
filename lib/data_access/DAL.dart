import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_z_money/Business_Logic/models/CustomUser.dart';

class FireStoreAccess {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void addUser(CustomUser newUser) async {
    await _db.collection("users").add(newUser.toMap());
  }

  Future<CustomUser>? getUser(User currUser) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("users")
        .where('email', isEqualTo: currUser.email)
        .get();
    if (snapshot.docs.isEmpty) {
      print("error");
    } else if (snapshot.docs.length == 1) {
      print(snapshot.docs.first.data());
      return CustomUser(
          snapshot.docs.first.data()["username"],
          snapshot.docs.first.data()["email"],
          snapshot.docs.first.data()["gender"],
          snapshot.docs.first.data()["age"],
          snapshot.docs.first.data()["phone"]);
    }
    return CustomUser("_username", "_email","");
  }
}

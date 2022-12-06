import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_z_money/Business_Logic/models/CustomUser.dart';

class DataAccessService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> createUser(CustomUser newUser) async {
    await _db.collection("users").add(newUser.toMap());
  }

  Future<void> updateUser(String uid, String field, dynamic toUpdate) async {
    await _db.collection("users").where("uid", isEqualTo: uid).get().then((result) => {
      if (result.size > 0) {
        result.docs.forEach((userDoc) => {
        _db.collection("users").doc(userDoc.id).update({ field: toUpdate })
        })
      }
    });
  }

  Future<CustomUser?> getUser(User currUser) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("users")
        .where('uid', isEqualTo: currUser.uid)
        .get();
    if (snapshot.docs.isEmpty) {
      print("error");
    } else if (snapshot.docs.length == 1) {
      print(snapshot.docs.first.data());
      return CustomUser(
          username: snapshot.docs.first.data()["Username"],
          email: snapshot.docs.first.data()["Email"],
          gender: snapshot.docs.first.data()["Gender"],
          age: snapshot.docs.first.data()["Age"],
          phoneNum: snapshot.docs.first.data()["Phone"],
          userType: snapshot.docs.first.data()["User Type"],
          hashPass: '');
    }
    return null;
  }
}
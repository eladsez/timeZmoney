import 'package:cloud_firestore/cloud_firestore.dart';

class Dal {
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();
}


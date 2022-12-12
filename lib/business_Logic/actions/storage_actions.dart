import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


 /// Doesn't working yet

class StorageAccess {
  String testImage = "/home/elad/token";

  final storageRef = FirebaseStorage.instance.ref();

  void uploadImage(String path) async {
    var file = File(testImage);
    var snapshot = await storageRef.putFile(file);
    print(snapshot.ref.getDownloadURL());
  }
}

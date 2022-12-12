import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_z_money/data_access/auth.dart';
import 'package:time_z_money/screens/Authenticate/components/profile_chooser.dart';
import '../../data_access/Firestore_dal.dart';
import '../../utils/helper_functions.dart';
import '../models/CustomUser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageAccess{
  String testImage = "D:\\study\\Ex1_CV-IP\\forest.jpeg";
  var Url;
  final storageRef = FirebaseStorage.instance.ref();
  void uploadImage(String path) async
  {
    final picRef = storageRef.child("testImage.jpeg");
    var file = File(testImage);
    var snapshot = await storageRef.child("testImage.jpeg").putFile(file);
    Url = snapshot.ref.getDownloadURL();
  }
}
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageAccess{

  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, String remoteFilePath) async {
    var snapshot = await _storage.ref().child(remoteFilePath)
        .putFile(File(path)).whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }
}
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler{

  static requestGalleryAccess() async{
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
    await Permission.mediaLibrary.request();
  }

  static galleryAccess() async{
    return await Permission.manageExternalStorage.status.isGranted;
  }

}
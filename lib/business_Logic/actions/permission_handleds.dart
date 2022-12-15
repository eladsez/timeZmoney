
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler{

  static requestGalleryAccess() async{
    await Permission.photos.request();
  }

  static galleryAccess() async{
    return await Permission.photos.status.isGranted;
  }

}
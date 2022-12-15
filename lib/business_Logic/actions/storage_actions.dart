import 'package:image_picker/image_picker.dart';
import 'package:time_z_money/business_Logic/actions/permission_handleds.dart';
import 'package:time_z_money/data_access/storage_dal.dart';


class StorageActions {

  final StorageAccess _access = StorageAccess();

  /*
  * This function get the image remote path you wish to name it on firebase storage
  * It opens a imagePicker window, get the imagePath from the device
  * upload the image to firebase storage and return the url of that image
  */
  Future<String> uploadImage(remotePath) async {

    bool permission = await PermissionHandler.galleryAccess();
    String netPath = "ERROR";
    if (!permission) {
      await PermissionHandler.requestGalleryAccess();
      permission = await PermissionHandler.galleryAccess();
    }
    if (!permission){
      // TODO: handle
      return netPath;
    }
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      netPath = await _access.uploadFile(image.path, remotePath);
    }
    return netPath;

  }
}

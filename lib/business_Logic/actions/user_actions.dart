import 'package:time_z_money/business_Logic/actions/storage_actions.dart';
import '../../data_access/firestore_dal.dart';
import '../models/CustomUser.dart';
import 'auth_actions.dart';

class UserActions {
  final DataAccessService das = DataAccessService();
  final StorageActions sac = StorageActions();

  /*
   * This function update a field in the currUser object (hold in AuthActions class)
   * Also update it in his fireStore document
   */
  void updateCurrUser(String field, dynamic toUpdate) async {
    await das.updateUser(
        AuthActions.currUser.uid, field, toUpdate); // update fireStore
    switch (field) {
      // update the current costume user
      case "age":
        AuthActions.currUser.age = toUpdate;
        break;
      case "gender":
        AuthActions.currUser.gender = toUpdate;
        break;
      case "about":
        AuthActions.currUser.about = toUpdate;
        break;
    }
  }

  Future<void> updateProfileImage() async {
    String imageUrl = await sac.uploadImage(
        "profileImages/" + AuthActions.currUser.uid + "-profileImage");
    if (imageUrl == "ERROR") return; // TODO: handle when not succeed
    await das.updateUser(AuthActions.currUser.uid, "profileImageURL", imageUrl); // update fireStore
    AuthActions.currUser.profileImageURL = imageUrl;
  }

  /*
   * This function update a field in the currUser object (hold in AuthActions class)
   * Also update it in his fireStore document
   */
  Future<CustomUser?> getUserByUid(String employerUid) async{
    return das.getCustomUserByUid(employerUid);
  }

  /*
   * get a list of CustomUser from a list of uid
   */
  Future<List<CustomUser>> getUsersFromUid(List<dynamic> uids) async {
    List<CustomUser> users = [];
    for (String uid in uids) {
      CustomUser? user = await das.getCustomUserByUid(uid);
      if (user != null) {
        users.add(user);
      }
    }
    return users;
  }


}

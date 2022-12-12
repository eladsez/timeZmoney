import '../../data_access/firestore_dal.dart';
import 'auth_actions.dart';

class UserActions{

  final DataAccessService das = DataAccessService();

  void updateCurrUser(String field, dynamic toUpdate) async{
    await das.updateUser(AuthActions.currUser.uid, field, toUpdate); // update fireStore
    switch (field){ // update the current costume user
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
}
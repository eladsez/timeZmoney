import '../../data_access/Firestore_dal.dart';
import 'auth_actions.dart';

class UserActions{

  final DataAccessService das = DataAccessService();

  void updateCurrUser(String field, dynamic toUpdate) async{
    await das.updateUser(AuthActions.currUser.uid, field, toUpdate);
  }
}
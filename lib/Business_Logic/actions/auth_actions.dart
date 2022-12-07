import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_z_money/Business_Logic/models/CustomUser.dart';
import 'package:time_z_money/data_access/auth.dart';
import 'package:time_z_money/screens/Authenticate/components/profile_chooser.dart';
import '../../data_access/DAL.dart';
import '../../utils/helper_functions.dart';

class AuthActions {
  static final DataAccessService das = DataAccessService();
  static final AuthService auth = AuthService();
  static late CustomUser currUser;

  login(CustomUser user) {
    currUser = user;
    auth.emailSignIn(user);
    currUser.uid = auth.getCurrUserUid();
    currUser.hashPass = HelperFunctions.generateMd5(currUser.hashPass);
  }

  signupFirstStage(CustomUser newUser) {
    // we give the password to firebase auth before hash
    auth.regularRegistration(newUser);
    currUser = newUser;
  }

  signupSecondStage() async {
    currUser.hashPass = HelperFunctions.generateMd5(currUser.hashPass);
    await das.createUser(currUser); // to fireStore we insert the password hashed
  }

  /// This function update the profile type of the user in firestore after the user singup and choose one from profileChooserScreen
  /// called after the signupSecondStage()
  chooseProfile(UserProfile profileType) async {
    await das.updateUser(currUser.uid!, "user type",
        profileType == UserProfile.employer ? "employer" : "worker");
  }

  /// This function will check if the uid of a firebase_auth user is already in fireStore
  ///  if it is - so we in signIn state
  ///  if not - we in signup second stage
  Future<bool> whichStateChange(User? firebaseUser) async {
    CustomUser? user = await das.getUser(firebaseUser!);
    return user != null;
  }
}

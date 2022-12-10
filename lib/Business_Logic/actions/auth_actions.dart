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

  static setCurrUser(CustomUser user){
    currUser = user.clone();
  }

  login(CustomUser user) async{
    setCurrUser(user);
    await auth.emailSignIn(user);
    currUser.uid = auth.getCurrUserUid();
    currUser.hashPass = HelperFunctions.generateMd5(currUser.hashPass);
  }

  /*
  The first stage signup sign the new user in fireBase auth and trigger the appWrapper stream
   */
  signupFirstStage() async {
    // we give the password to firebase auth before hash
    await auth.regularRegistration(currUser);
  }

  Future<void> signupSecondStage() async {
    currUser.hashPass = HelperFunctions.generateMd5(currUser.hashPass); // to fireStore we insert the password hashed
    currUser.uid = auth.getCurrUserUid(); // update the user uid for fireStore
    await das.createUser(currUser);
  }

/*
  This function update the profile of the signed up currUser and call the first stage signup
 */
  chooseProfile(UserProfile profileType) async {
    currUser.userType = (profileType == UserProfile.employer) ? "employer" : "worker";
    // await das.updateUser(currUser?.uid!, "user type",
    //     profileType == UserProfile.employer ? "employer" : "worker");
    await signupFirstStage();
  }

  /// This function will check if the uid of a firebase_auth user is already in fireStore
  ///  if it is - so we in signIn state
  ///  if not - we in signup second stage
  Future<bool> whichStateChange(User? firebaseUser) async {
    CustomUser? user = await das.getCustomUser(firebaseUser!);
    if (user == null){
      return false;
    }
    else{
      setCurrUser(user);
      return true;
    }
  }
}

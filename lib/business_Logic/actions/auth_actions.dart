import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:time_z_money/data_access/auth.dart';
import 'package:time_z_money/screens/Authenticate/components/profile_chooser.dart';
import '../../data_access/firestore_dal.dart';
import '../../utils/helper_functions.dart';
import '../models/CustomUser.dart';

/*
  This class is responsible about the Authentication process
  It connects the presentation layer with the firebase_auth and fireStore
  It uses the DataAccessService and AuthService to implement an abstraction
  for the Authentication process (simple functions like login, signupFirstStage and signupSecondStage)
*/

class AuthActions {
  final DataAccessService das = DataAccessService();
  final AuthService auth = AuthService();
  static bool googleSignIn = false;
  static dynamic currUser;

  static tryInitCurrUser() {
    // TODO: consider to init currUser from the beginning
  }

  static setCurrUser(CustomUser user) {
    currUser = user.clone();
  }

// TODO: catch the error and return it to the presentation layer
  login(CustomUser user) async {
    await auth.emailSignIn(user);
    CustomUser? curr = await das.getCustomUser(auth.getCurrFireBaseUser());
    setCurrUser(curr!);
  }

  Future google() async {
    await auth.googleSignUp();
  }

  /*
  The first stage signup sign the new user in fireBase auth and trigger the appWrapper stream
  */
  Future<String> signupFirstStage() async {
    // we give the password to firebase auth before hash
    return await auth.regularRegistration(currUser);
  }

  Future<void> signupSecondStage({String userType = ""}) async {
    if (currUser == null) {
      // we in google signup, we don't gonna hold hash password for him
      String username = auth.getCurrFireBaseUser().displayName ??
          ""; // after ?? will never happened
      String email = auth.getCurrFireBaseUser().email ?? "";
      setCurrUser(CustomUser(
          username: username, email: email, hashPass: "", userType: userType));
    } else {
      currUser.hashPass = HelperFunctions.generateMd5(
          currUser.hashPass); // to fireStore we insert the password hashed
    }
    currUser.uid = auth.getCurrUserUid(); // update the user uid for fireStore
    await das.createUser(currUser);
  }

/*
  This function update the profile of the signed up currUser and call the first stage signup
 */
  Future<String> chooseProfile(UserProfile profileType) async {
    currUser.userType =
        (profileType == UserProfile.employer) ? "employer" : "worker";
    return await signupFirstStage();
  }

  signOut() async {
    if (googleSignIn) {
      googleSignIn = false;
      GoogleSignIn().signOut();
    }
    await FirebaseAuth.instance.signOut();
  }

  /// This function will check if the uid of a firebase_auth user is already in fireStore
  ///  if it is - so we in signIn state
  ///  if not - we in signup second stage
  Future<bool> whichStateChange(User? firebaseUser) async {
    if (currUser == null) {
      googleSignIn = true;
    }
    CustomUser? user = await das.getCustomUser(firebaseUser!);
    if (user == null) {
      return false;
    } else {
      setCurrUser(user);
      return true;
    }
  }
}

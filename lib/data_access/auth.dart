import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../business_Logic/models/CustomUser.dart';

enum AuthProblems { userNotFound, passwordNotValid, networkError }

class AuthService {

  static Stream<User?> getAuthState(){
    return FirebaseAuth.instance.authStateChanges();
  }

  String? getCurrUserUid(){
    return FirebaseAuth.instance.currentUser?.uid;
  }

  User? getCurrFireBaseUser(){
    return FirebaseAuth.instance.currentUser;
  }

  Future<String> regularRegistration(CustomUser newUser) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: newUser.email,
        password: newUser.hashPass,
      );
      return "OK";
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future emailSignIn(CustomUser user) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email, password: user.hashPass);
    } catch (e) {
      AuthProblems errorType;
      print(e);
      switch (e.toString()) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = AuthProblems.userNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = AuthProblems.passwordNotValid;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = AuthProblems.networkError;
          break;
        default:
          print('Case ${e.toString()} is not yet implemented');
      }
    }
  }


  Future googleSignIn(CustomUser user) async{

    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ["email"]).signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

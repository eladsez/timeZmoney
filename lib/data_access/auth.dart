import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_z_money/Business_Logic/models/CustomUser.dart';

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

  Future regularRegistration(CustomUser newUser) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: newUser.email,
        password: newUser.hashPass,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {

      } else if (e.code == 'email-already-in-use') {

      }
    } catch (e) {
      print(e);
    }
  }

  Future emailSignIn(CustomUser user) async {
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
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
}

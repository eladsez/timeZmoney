import 'package:firebase_auth/firebase_auth.dart';

class CustomUser {
  var _uid;
  var _username;
  var _email;
  var _phoneNum;
  var _gender;
  var _age;
  var _hashPassword;

  CustomUser(
      this._username, this._email, this._hashPassword, this._gender, this._age,
      [this._phoneNum]);

  userFromFirebaseUser(User firebaseUser) {}

  String getEmail() {
    return _email;
  }

  String getHashPassword() {
    return _hashPassword;
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class CustomUser {
  var _uid;
  var _username;
  var _email;
  var _phoneNum;
  var _gender;
  var _age;
  var _hashPass;

  CustomUser(
      this._username, this._email, this._hashPass,[this._gender, this._age,
      this._phoneNum]);

  Map<String,dynamic> toMap()
  {
    return {"username":_username,"email":_email,"phone":_phoneNum,"gender":_gender,"age":_age};
  }

  String getEmail() {
    return _email;
  }

  String getHashPassword()
  {
    return _hashPass;
  }

}

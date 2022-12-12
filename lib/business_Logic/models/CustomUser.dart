class CustomUser {
  String? uid;
  String username;
  String hashPass;
  String email;
  String? phoneNum;
  String? gender;
  int? age;
  String? userType;
  String about;

  CustomUser(
      {required this.username,
      required this.email,
      required this.hashPass,
      this.uid = "ERROR",
      this.gender = "Choose your preferred referral method",
      this.age = 18,
      this.phoneNum = "Empty",
      this.userType,
      this.about = "Empty"});

  CustomUser clone() {
    // deep copy of the object
    return CustomUser(
        username: username,
        email: email,
        hashPass: hashPass,
        uid: uid,
        gender: gender,
        age: age,
        phoneNum: phoneNum,
        userType: userType);
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "phone": phoneNum,
      "gender": gender,
      "age": age,
      "user type": userType,
      "hashPass": hashPass,
      "about": about,
    };
  }
}

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
  String profileImageURL;

  CustomUser(
      {required this.username,
      required this.email,
      required this.hashPass,
      this.uid = "ERROR",
      this.gender = "Choose your preferred referral method",
      this.age = 18,
      this.phoneNum = "Empty",
      this.userType,
      this.about = "Empty",
      this.profileImageURL =
          "https://firebasestorage.googleapis.com/v0/b/timezmoney.appspot.com/o/profileImages%2Favatar.png?alt=media&token=afb28a2b-1189-4dac-b114-e09c68b5b82e"});

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
        userType: userType,
        about: about,
        profileImageURL: profileImageURL);
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
      "profileImageURL": profileImageURL,
    };
  }

  static CustomUser fromMap(Map<String, dynamic> user) {
    return CustomUser(
      username: user["username"],
      email: user["email"],
      gender: user["gender"],
      age: user["age"],
      phoneNum: user["phone"],
      userType: user["user Type"],
      hashPass: user["hashPass"],
      uid: user["uid"],
      about: user["about"],
      profileImageURL: user["profileImageURL"],
    );
  }
}

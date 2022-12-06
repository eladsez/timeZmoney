class CustomUser {
  String? uid;
  String username;
  String hashPass;
  String email;
  String? phoneNum;
  String? gender;
  int? age;
  String? userType;

  CustomUser(
      {required this.username,
      required this.email,
      required this.hashPass,
      this.uid = " ",
      this.gender = " ",
      this.age = 18,
      this.phoneNum = " ",
      this.userType = " "});

  Map<String, dynamic> toMap() {
    return {
      "uid":uid ,
      "username": username,
      "email": email,
      "phone": phoneNum,
      "gender": gender,
      "age": age,
      "user type": userType,
      "hashPass": hashPass,
    };
  }
}

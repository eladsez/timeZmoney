import 'package:flutter/material.dart';
import '../../business_Logic/actions/auth_actions.dart';
import '../../business_Logic/actions/user_actions.dart';
import 'components/profile_circle.dart';
import 'components/textfield_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController aboutController;
  late final TextEditingController ageController;
  late final TextEditingController genderController;
  final userActions = UserActions();

  @override
  void initState() {
    aboutController = TextEditingController();
    genderController = TextEditingController();
    ageController = TextEditingController();
    aboutController.text = AuthActions.currUser.about == "Empty"
        ? "Your about is currently empty, Press the edit button to write it!"
        : AuthActions.currUser.about;
    genderController.text = AuthActions.currUser.gender;
    ageController.text = AuthActions.currUser.age.toString();
    super.initState();
  }

  @override
  void dispose() {
    aboutController.dispose();
    genderController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Color(0xff01b2b8)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileWidget(
                imagePath: AuthActions.currUser.profileImageURL,
                isEdit: true,
                onClicked: () async {
                  await userActions.updateProfileImage();
                  setState(() {});
                }),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: TextFieldWidget(
                    align: TextAlign.center,
                    label: 'Age',
                    text: ageController.text,
                    controller: ageController,
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 100,
                  child: TextFieldWidget(
                    align: TextAlign.center,
                    label: 'Gender',
                    text: genderController.text,
                    controller: genderController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              align: TextAlign.left,
              label: 'About',
              maxLines: 5,
              controller: aboutController,
              text: aboutController.text,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff01b2b8),
                shape: const StadiumBorder(),
                onPrimary: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                userActions.updateCurrUser(
                    "age", int.parse(ageController.text));
                userActions.updateCurrUser("about", aboutController.text);
                userActions.updateCurrUser("gender", genderController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            )
          ],
        ));
  }
}

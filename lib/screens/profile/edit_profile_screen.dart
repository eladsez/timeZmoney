import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../business_Logic/actions/auth_actions.dart';
import '../../business_Logic/actions/user_actions.dart';
import '../../utils/helper_functions.dart';
import '../../utils/theme.dart';
import 'components/profile_circle.dart';
import 'components/textfield_widget.dart';

class EditProfileScreen extends StatefulWidget {
  
  final ValueChanged<void> updateProfile;

  const EditProfileScreen({super.key, required this.updateProfile});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
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
        ? ""
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
    var ages = List<int>.generate(120 - 16, (i) => i + 16);
    var genders = ['Male', 'Female', "Undefined"];
    return Scaffold(
      backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          leading: BackButton(color: theme.backArrowColor),
          backgroundColor: Colors.transparent,
          elevation: theme.elevation,
          foregroundColor: theme.appBarColor,
          toolbarHeight: (MediaQuery.of(context).size.height * 0.135)/2,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileCircle(
              theme: theme,
                imagePath: AuthActions.currUser.profileImageURL,
                isEdit: true,
                onClicked: () async {
                  await userActions.updateProfileImage();
                  setState(() {});
                }, user: AuthActions.currUser,),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: 100,
                    child: Column(
                      children: [
                        Text('Age', style: TextStyle(color: theme.titleColor)),
                        const Padding(padding: EdgeInsets.all(3)),
                        // add smalls arrows to the sides of the dropdown
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 0.05),
                              child: Icon(
                                  CupertinoIcons.chevron_up_chevron_down,
                                  color: theme.secondaryIconColor,
                                  size: 17),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                    initialItem:
                                        ages.indexOf(AuthActions.currUser.age)),
                                backgroundColor: theme.cardColor,
                                itemExtent: 32.0,
                                onSelectedItemChanged: (int index) {
                                  setState(() {
                                    ageController.text = ages[index].toString();
                                  });
                                },
                                children: List<Widget>.generate(ages.length,
                                    (int index) {
                                  return Center(
                                    child: Text(ages[index].toString(), style: TextStyle(color: theme.textFieldTextColor)),
                                  );
                                }),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                const SizedBox(width: 24),
                SizedBox(
                    width: 150,
                    child: Column(
                      children: [
                        Text('Gender', style: TextStyle(color: theme.titleColor)),
                        const Padding(padding: EdgeInsets.all(3)),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 0.05),
                              child: Icon(
                                  CupertinoIcons.chevron_up_chevron_down,
                                  color: theme.secondaryIconColor,
                                  size: 17),
                            ),
                            SizedBox(
                              width: 120,
                              // child: Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                    initialItem: genders
                                        .indexOf(AuthActions.currUser.gender)),
                                backgroundColor: theme.cardColor,
                                itemExtent: 30.0,
                                onSelectedItemChanged: (int index) {
                                  setState(() {
                                    genderController.text = genders[index];
                                  });
                                },
                                children: List<Widget>.generate(genders.length,
                                    (int index) {
                                  return Center(
                                    child: Text(genders[index], style: TextStyle(color: theme.textFieldTextColor)),
                                  );
                                }),
                              ),
                              // ),
                            ),
                          ],
                        )
                      ],
                    )),
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
                backgroundColor: theme.accentColor,
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
                widget.updateProfile("dummy");
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            )
          ],
        ));
  }
}

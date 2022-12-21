import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:time_z_money/screens/Authenticate/components/profile_chooser.dart';
import '../../../business_Logic/actions/auth_actions.dart';
import '../../../business_Logic/models/CustomUser.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';

enum SignupLoginState {
  signIn,
  logIn,
}

class SignupLoginContent extends StatefulWidget {
  const SignupLoginContent({Key? key}) : super(key: key);

  @override
  State<SignupLoginContent> createState() => _SignupLoginContentState();
}

class _SignupLoginContentState extends State<SignupLoginContent>
    with TickerProviderStateMixin {
  late List<Widget> createAccountContent;
  late List<Widget> loginContent;
  Map<String, TextEditingController> controllers = {};
  Map<String, GlobalKey<FormState>> formKeys = {};
  AuthActions authActions = AuthActions();

  Widget inputField(
      String hint, IconData iconData, bool passwd, String keyName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 2),
      child: SizedBox(
        height: 70,
        child: Material(
          elevation: 25,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          child: Form(
            key: formKeys[keyName],
            child: TextFormField(
              validator: HelperFunctions.validatorFunctions(hint),
              controller: controllers[hint],
              obscureText: passwd,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                counterText: ' ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff01b2b8)),
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: hint,
                prefixIcon: Icon(iconData),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget authButton(String title, void Function() handler) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: handler,
        style: ElevatedButton.styleFrom(
          backgroundColor: loginButtonColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: loginUnBoldColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: loginUnBoldColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset('assets/images/facebook.png'),
          ),
          const SizedBox(width: 24),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset('assets/images/google.png'),
          ),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: loginTextColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    controllers["Username"] = TextEditingController();
    controllers["Email"] = TextEditingController();
    controllers["Password"] = TextEditingController();
    controllers["Username"] = TextEditingController();
    formKeys["Username"] = GlobalKey<FormState>();
    formKeys["Email_login"] = GlobalKey<FormState>();
    formKeys["Email_signup"] = GlobalKey<FormState>();
    formKeys["Password_login"] = GlobalKey<FormState>();
    formKeys["Password_signup"] = GlobalKey<FormState>();

    createAccountContent = [
      inputField('Username', Ionicons.person_outline, false, "Username"),
      inputField('Email', Ionicons.mail_outline, false, "Email_signup"),
      inputField(
          'Password', Ionicons.lock_closed_outline, true, "Password_signup"),
      authButton('Sign Up', () {

        List<bool> invalid = [ // must be init like that
          !formKeys["Username"]!.currentState!.validate(),
          !formKeys["Email_signup"]!.currentState!.validate(),
          !formKeys["Password_signup"]!.currentState!.validate()
        ];

        if (invalid[0] || invalid[1] || invalid[2]) {
          return;
        }
        // when signup is pressed it set the currUser and push the ProfileChooserScreen
        AuthActions.setCurrUser(
          CustomUser(
              username: controllers["Username"]!.text.trim(),
              email: controllers["Email"]!.text.trim(),
              hashPass: controllers["Password"]!.text.trim()),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProfileChooserScreen()));
      }),
      orDivider(),
      logos(),
    ];

    loginContent = [
      inputField('Email', Ionicons.mail_outline, false, "Email_login"),
      inputField(
          'Password', Ionicons.lock_closed_outline, true, "Password_login"),
      authButton('Log In', () {
        List<bool> invalid = [!formKeys["Email_login"]!.currentState!.validate(), !formKeys["Password_login"]!.currentState!.validate()];
        if ( invalid[0]|| invalid[1]) {
          return;
        }
        authActions.login(
          CustomUser(
              username: controllers["Username"]!.text.trim(),
              email: controllers["Email"]!.text.trim(),
              hashPass: controllers["Password"]!.text.trim()),
        );
        FocusScope.of(context).requestFocus(FocusNode());
      }),
      forgotPassword(),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (int i = 0; i < createAccountContent.length; ++i) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
          animation: ChangeScreenAnimation.createAccountAnimations[i],
          child: createAccountContent[i]);
    }
    for (int i = 0; i < loginContent.length; ++i) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();
    ChangeScreenAnimation.currentScreen = SignupLoginState.signIn;
    controllers["Username"]?.dispose();
    controllers["Email"]?.dispose();
    controllers["Password"]?.dispose();
    loginContent = [];
    createAccountContent = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: TopLogo(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
        ),
      ],
    );
  }
}

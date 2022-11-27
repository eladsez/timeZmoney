import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:time_z_money/Business_Logic/models/CustomUser.dart';
import 'package:time_z_money/data_access/auth.dart';
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
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  Widget inputField(String hint, IconData iconData, bool passwd,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            controller: controller,
            obscureText: passwd,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: loginTextColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    createAccountContent = [
      inputField(
          'Username', Ionicons.person_outline, false, usernameController),
      inputField('Email', Ionicons.mail_outline, false, emailController),
      inputField(
          'Password', Ionicons.lock_closed_outline, true, passwordController),
      authButton('Sign Up', () {
        AuthService.regularRegistration(CustomUser(
            usernameController.text.trim(), emailController.text.trim(),
            passwordController.text.trim()));
      }),
      orDivider(),
      logos(),
    ];

    loginContent = [
      inputField('Email', Ionicons.mail_outline, false, emailController),
      inputField(
          'Password', Ionicons.lock_closed_outline, true, passwordController),
      authButton('Log In', () {
        AuthService.emailSignIn(CustomUser(usernameController.text.trim(),
            emailController.text.trim(), passwordController.text.trim()));
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
          padding: const EdgeInsets.only(top: 100),
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

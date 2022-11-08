import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:time_z_money/data_access/auth.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';

enum SignupLoginState {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late final Map<String, Widget> createAccountContent;
  late final Map<String, Widget> loginContent;
  final List<Widget> loginContentAnimated = [];
  final List<Widget> createAccountContentAnimated = [];
  String username = '';
  String password = '';
  String email = '';
  final AuthService _auth = AuthService();
  Widget inputField(String hint, IconData iconData, bool passwd, Function onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            onChanged: (val){
              onChange(val);
            },
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
    int index = 0;
    createAccountContent = {
      "username": inputField('Username', Ionicons.person_outline, false,(String val){username = val;}),
      "email": inputField('Email', Ionicons.mail_outline, false,(String val){email = val;}),
      "password": inputField('Password', Ionicons.lock_closed_outline, true,(String val){password = val;}),
      "signupButton": authButton('Sign Up', () {
        print(username);print(email);print(password);
      }),
      "or": orDivider(),
      "logos": logos(),
    };

    loginContent = {
      "EmailUsername":
          inputField('Email / Username', Ionicons.mail_outline, false,(String val){email = val;}),
      "password": inputField('Password', Ionicons.lock_closed_outline, true,(String val){password = val;}),
      "loginButton": authButton('Log In', () {}),
      "forgotPasswordButton": forgotPassword(),
    };

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    createAccountContent.forEach((key, value) {
      createAccountContentAnimated.add(HelperFunctions.wrapWithAnimatedBuilder(
          animation: ChangeScreenAnimation.createAccountAnimations[index++],
          child: value));
    });

    index = 0;

    loginContent.forEach((key, value) {
      loginContentAnimated.add(HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[index++],
        child: value,
      ));
    });
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
                children: createAccountContentAnimated,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContentAnimated,
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

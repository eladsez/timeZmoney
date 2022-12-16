import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/data_access/auth.dart';
import 'package:time_z_money/screens/Authenticate/Authenticate_screen.dart';
import 'package:time_z_money/screens/main_screen.dart';
import '../business_Logic/actions/auth_actions.dart';
import 'Loading_Screens/loading_logo.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  
  late final AuthActions authActions = AuthActions();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: AuthService.getAuthState(),
          builder: (context, user) {
            if (user.hasData && user.data is User) {// we got a user
              return FutureBuilder(
                  // check if we already had the user in fireStore
                  future: authActions.whichStateChange(user.data),
                  builder: (_, loginState) {
                    if (loginState.hasData && loginState.data == false) {
                      // we don't have it in fireStore, so we in signup state
                      return FutureBuilder(
                        // create the fireStore entry for the user and only then build home
                        future: authActions.signupSecondStage(),
                        builder: (context, dummy) {
                          return const MainScreen();
                        },
                      );
                    } else if (loginState.hasData && loginState.data == true) {
                      // in case we in signIn
                      return const MainScreen();
                    } else {
                      return const LoadingLogo();
                    }
                  });
            }
            return const Authenticate();
          }),
    );
  }
}

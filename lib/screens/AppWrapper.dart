import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/Business_Logic/actions/auth_actions.dart';
import 'package:time_z_money/data_access/auth.dart';
import 'package:time_z_money/screens/Authenticate/Authenticate_screen.dart';
import 'package:time_z_money/screens/home/home.dart';
import 'Authenticate/components/profile_chooser.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final AuthActions authActions = AuthActions();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: AuthService.getAuthState(),
          initialData: FirebaseAuth.instance.currentUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) { // we got a user
              AuthActions.currUser.uid = snapshot.data?.uid; // save the uid of the firebase_auth user on the customUser for fireStore
              return FutureBuilder( // check if we already had the user in fireStore
                  future: authActions.whichStateChange(snapshot.data),
                  builder: (_, snap) {
                    if (snap.hasData && snap.data == false){  // we don't have it in fireStore, so we in signup state
                      authActions.signupSecondStage(); // create the firestore entry for th user
                      return const ProfileChooserScreen();  // next we build the Profile chooser screen
                    }
                    else {// in case we in signIn
                      // return const Home();
                      return const Authenticate();
                    }
                  });
            }
            return const Authenticate();
          }),
    );
  }
}

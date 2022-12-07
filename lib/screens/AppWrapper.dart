import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/Business_Logic/actions/auth_actions.dart';
import 'package:time_z_money/data_access/auth.dart';
import 'package:time_z_money/screens/Authenticate/Authenticate_screen.dart';
import 'package:time_z_money/screens/home/home.dart';
import 'Authenticate/components/profile_chooser.dart';
import 'Loading_Screens/clock_loader_particles.dart';

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
          builder: (context, authState) {
            if (authState.hasData && authState.data is User) {
              // we got a user
              return FutureBuilder(
                  // check if we already had the user in fireStore
                  future: authActions.whichStateChange(authState.data),
                  builder: (_, signUpState) {
                    if (signUpState.hasData && signUpState.data == false) { // we don't have it in fireStore, so we in signup state
                      return FutureBuilder(  // create the fireStore entry for the user and only then build home
                        future: authActions.signupSecondStage(),
                        builder: (context, dummy) {
                          return const Home();
                        },
                      );
                    } else if (signUpState.hasData && signUpState.data == true) {
                      // in case we in signIn
                      return const Home();
                    } else {
                      return ClockLoader(
                        clockLoaderModel: ClockLoaderModel(
                          shapeOfParticles: ShapeOfParticlesEnum.circle,
                          mainHandleColor: Colors.white,
                          particlesColor: Colors.white,
                        ),
                      );;
                    }
                  });
            }
            return const Authenticate();
          }),
    );
  }
}

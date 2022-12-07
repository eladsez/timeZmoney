import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Home page for now")),
      floatingActionButton: FloatingActionButton(
        child: const Text("sign out"),
        onPressed:(){
          FirebaseAuth.instance.signOut();
        }
      ),
    );
  }
}

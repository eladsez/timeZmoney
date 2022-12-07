import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("home page for now"),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
        }
      ),
    );
  }
}

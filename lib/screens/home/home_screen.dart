import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../template2/widgets/searchbar.dart';
import '../template2/widgets/tag_list.dart';
import 'home_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
          Column(
            children: const [
              HomeAppbar(),
            ],
          ),
        ],
      ),
    );
  }
}

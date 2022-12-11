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
              // const SizedBox(
              //   height: 6,
              // ),
              // const Text("Find your perfect job",
              //     textAlign: TextAlign.left,
              //     style: TextStyle(
              //         fontSize: 17,
              //         color: KColors.title,
              //         fontWeight: FontWeight.bold)),
              //
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         padding:
              //             const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //         decoration: BoxDecoration(
              //             color: KColors.lightGrey,
              //             borderRadius: BorderRadius.circular(5)),
              //         child: const Text(
              //           "What are you looking for?",
              //           style: TextStyle(fontSize: 15, color: KColors.subtitle),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 16,
              //     ),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: KColors.primary,
              //         borderRadius: BorderRadius.circular(5),
              //       ),
              //       height: 40,
              //       child: IconButton(
              //         color: KColors.primary,
              //         icon: const Icon(Icons.search, color: Colors.white),
              //         onPressed: () {},
              //       ),
              //     )
                ],
              // )
            // ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Text("sign out"),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          }),
    );
  }
}

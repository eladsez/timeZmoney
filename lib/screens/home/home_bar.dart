import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, //for responsive
          left: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Welcome Home',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Rick Sanchez',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  margin: const EdgeInsets.only(top: 40, right: 17),
                  transform: Matrix4.rotationZ(100),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: Badge(
                          badgeContent: const Text(
                            "5",
                            style: TextStyle(color: Colors.white),
                          ),
                          showBadge: true,
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.black26,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipOval(
                  child: Image.asset('assets/images/avatar.png', width: 50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

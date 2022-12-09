import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'explore.dart';
import 'settings.dart';

enum BottomNavigationBarState {
  dashboard,
  explore,
  setting,
  more, // need to modify
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BottomNavigationBarState selectedNavBar = BottomNavigationBarState.dashboard;

  Widget screen(BottomNavigationBarState currState) {
    switch (currState) {
      case BottomNavigationBarState.dashboard:
        return const Dashboard();
      case BottomNavigationBarState.explore:
        return const Explore();
      case BottomNavigationBarState.setting:
        return const Settings();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen(selectedNavBar),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedNavBar = BottomNavigationBarState.dashboard;
                  });
                },
                color: selectedNavBar == BottomNavigationBarState.dashboard
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.home_filled)),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedNavBar = BottomNavigationBarState.explore;
                  });
                },
                color: selectedNavBar == BottomNavigationBarState.explore
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.explore)),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedNavBar = BottomNavigationBarState.setting;
                  });
                },
                color: selectedNavBar == BottomNavigationBarState.setting
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.settings)),
            IconButton(
                onPressed: () {
                  setState(() {
                    selectedNavBar = BottomNavigationBarState.more;
                  });
                },
                color: selectedNavBar == BottomNavigationBarState.more
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
                icon: const Icon(Icons.favorite)),
          ],
        ),
      ),
    );
  }
}

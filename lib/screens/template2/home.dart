import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/template2/widgets/searchbar.dart';
import 'package:time_z_money/screens/template2/widgets/tag_list.dart';
import '../home/home_bar.dart';

enum BottomNavigationBarState {
  dashboard,
  explore,
  setting,
  more, // need to modify
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  BottomNavigationBarState selectedNavBar = BottomNavigationBarState.dashboard;

  /*
  This function build the body of are app depend on the selectedNavBar
   */
  Widget bodyBuilder(){
    switch (selectedNavBar) {
      // case BottomNavigationBarState.dashboard:
      //   return const Dashboard();
      // case BottomNavigationBarState.explore:
      //   return const Explore();
      // case BottomNavigationBarState.setting:
      //   return const Settings();
      default:
        return Container();
    }
  }

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
              SearchBar(),
              // TagList(),
              // CompanyList(),

            ],
          ),
        ],
      ),
     /* floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add, color: Colors.white),
      ),

      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent
        ),

       child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home, size: 25)
            ),
            BottomNavigationBarItem(
                label: 'Case',
                icon: Icon(Icons.cases_outlined, size: 25)
            ),
            BottomNavigationBarItem(
                label: '',
                icon: Text(''),
            ),
            BottomNavigationBarItem(
                label: 'Chat',
                icon: Icon(Icons.chat_bubble_outline_sharp, size: 25)
            ),
            BottomNavigationBarItem(
                label: 'person',
                icon: Icon(Icons.person_outline_rounded, size: 25)
            ),
          ],
        ),


        ),*/

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: CurvedNavigationBar(

          color: Colors.white,
          backgroundColor: Colors.grey.withOpacity(0.1),
          buttonBackgroundColor:  Colors.yellow,
          height: 50,
          items: const <Widget>[
            Icon(Icons.home, size: 26, color: Color(0xff01b2b8)),
            Icon(Icons.cases_outlined, size: 26, color: Color(0xff01b2b8)),
            Icon(Icons.add_outlined, size: 28, color: Color(0xff01b2b8)),
            Icon(Icons.chat_bubble_outline_sharp, size: 26, color: Color(0xff01b2b8)),
            Icon(Icons.person_outline_rounded, size: 26, color: Color(0xff01b2b8)),
          ],
          animationDuration: const Duration(
            microseconds: 200
          ),
          index: 2,
          animationCurve: Curves.bounceInOut,
          onTap: (index){
             debugPrint("Current Index is $index");
          },
        ),
      ),


    );
  }
}

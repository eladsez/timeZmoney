import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/actions/auth_actions.dart';
import 'package:time_z_money/screens/profile/profile_screen.dart';


import '../../../business_Logic/actions/user_actions.dart';
import '../../../business_Logic/models/CustomUser.dart';
import '../../../business_Logic/models/Job.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';

class CoWorkersList extends StatefulWidget {
  CoWorkersList({super.key, required this.job});

  late Job job;

  @override
  State<CoWorkersList> createState() => _CoWorkersListState();
}

class _CoWorkersListState extends State<CoWorkersList> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  UserActions userActions = UserActions();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Text(
          "Co-Workers",
          style: TextStyle(
              fontSize: 20, color: theme.titleColor, fontWeight: FontWeight.bold),
        ),
        // add separator
        Container(
          height: 0.5,
          width: double.infinity,
          color: theme.secondaryIconColor,
          margin: const EdgeInsets.symmetric(vertical: 5),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // make sure the widgets doesn't overflow
          mainAxisSize: MainAxisSize.min,
          children: [
            // wait list
            buildListOfCoWorkers(),
          ],
        ),
      ],
    );
  }

  Widget buildListOfCoWorkers() {
    return ConstrainedBox(
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.41),
        child: FutureBuilder<List<CustomUser>>(
            future: userActions.getUsersFromUid(widget.job.approvedWorkers.map((uid_s) => uid_s.split(",")[0]).toList()),
            builder: (context, AsyncSnapshot<List<CustomUser>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty && snapshot.data!.length > 1) {
                  var applicants = snapshot.data;
                  // remmove the current user from the list
                  applicants!.removeWhere((element) => element.uid == AuthActions.currUser!.uid);
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: applicants.length,
                      itemBuilder: (context, userIndex) => ListTile(
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: -1),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                applicants[userIndex].profileImageURL),
                            radius: 13,
                          ),
                          title: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              applicants[userIndex].username,
                              style: TextStyle(fontSize: 12, color: theme.nameColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    user: applicants[userIndex],
                                  )
                              )
                          )
                      )
                  );
                } else {
                  return Center(
                    child: Text("It seems like you are the only one here :(",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.textFieldTextColor,
                      ),),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
    );
  }

}

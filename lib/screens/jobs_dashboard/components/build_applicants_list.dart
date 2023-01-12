import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/actions/user_actions.dart';
import 'package:time_z_money/screens/profile/profile_screen.dart';

import '../../../business_Logic/actions/jobs_actions.dart';
import '../../../business_Logic/models/CustomUser.dart';
import '../../../business_Logic/models/Job.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';

class BuildApplicantsList extends StatefulWidget {
  BuildApplicantsList({super.key, required this.job});

  late Job job;

  @override
  State<BuildApplicantsList> createState() => _BuildApplicantsListState();
}

class _BuildApplicantsListState extends State<BuildApplicantsList> {
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
          "Applicants",
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Wait list",
              style: TextStyle(
                  fontSize: 20,
                  color: theme.titleColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Approved",
              style: TextStyle(
                  fontSize: 20,
                  color: theme.titleColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // make sure the widgets doesn't overflow
          mainAxisSize: MainAxisSize.min,
          children: [
            // wait list
            buildListOfApplicants(true),
            Divider(
              color: theme.secondaryIconColor,
              thickness: 0.5,
              indent: 10,
              endIndent: 10,
            ),
            // approved list
            buildListOfApplicants(false),
          ],
        ),
      ],
    );
  }

  Widget buildListOfApplicants(bool isApplied) {
    return ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.41),
        child: FutureBuilder<List<CustomUser>>(
            future: isApplied
                ? userActions.getUsersFromUid(widget.job.signedWorkers)
                : userActions.getUsersFromUid(widget.job.approvedWorkers.map((cut) => cut.split(",")[0]).toList()),
            builder: (context, AsyncSnapshot<List<CustomUser>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  var applicants = snapshot.data;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: applicants?.length,
                      itemBuilder: (context, userIndex) => ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: -1),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                applicants![userIndex].profileImageURL),
                            radius: 13,
                          ),
                          title: Text(
                            applicants[userIndex].username,
                            style: TextStyle(fontSize: 12, color: theme.nameColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // subtitle: Text(applicantApplied[index].email),
                          trailing: IconButton(
                              onPressed: () => setState(() {
                                    if (isApplied &&
                                        widget.job.amountNeeded >
                                            widget.job.approvedWorkers.length) {
                                      applicantsApprovalPopup(
                                          applicants[userIndex],
                                          userIndex,
                                          true);
                                    } else if (!isApplied) {
                                      applicantsApprovalPopup(
                                          applicants[userIndex],
                                          userIndex,
                                          false);
                                    } else {
                                      fullPopup();
                                    }
                                  }),
                              icon: Icon(
                                isApplied ? Icons.check : Icons.cancel_outlined,
                                size: 25,
                                color: isApplied ? Colors.green : Colors.red,
                              )),
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
                    child: Text("No applicants yet", style: TextStyle(color: theme.textFieldTextColor)),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }


  Future applicantsApprovalPopup(
      CustomUser user, int userIndex, bool isApplied) async {
    return showDialog(
      barrierColor: Colors.grey.withOpacity(0.1),
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: isApplied
              ? Text(
                  "Approve User",
                  style: TextStyle(
                      color: theme.titleColor, fontWeight: FontWeight.bold),
                )
              : Text(
                  "Remove User",
                  style: TextStyle(
                      color: theme.titleColor, fontWeight: FontWeight.bold),
                ),
          content: isApplied
              ? Text("Are you sure you want to add this user to the job?", style: TextStyle(color: theme.textFieldTextColor))
              : Text(
                  "Are you sure you want to remove this user from the job?", style: TextStyle(color: theme.textFieldTextColor)),
          actions: [
            TextButton(
              onPressed: () async {
                isApplied
                    ? JobsActions().approveUserToJob(widget.job, user.uid)
                    : JobsActions().removeUserFromJob(widget.job, user.uid);
                setState(() {
                  // get the updated job from the database
                  JobsActions().getJobByUid(widget.job.uid).then((value) {
                    widget.job = value!;
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void fullPopup() {
    showDialog(
      barrierColor: Colors.grey.withOpacity(0.1),
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Text("Error", style: TextStyle(color: theme.titleColor)),
          content: Text("You can't add more workers to the job", style: TextStyle(color: theme.textFieldTextColor)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ok", style: TextStyle(color: theme.accentColor)),
            ),
          ],
        );
      },
    );
  }
}

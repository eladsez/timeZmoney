import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/profile/profile_screen.dart';

import '../../../business_Logic/actions/jobs_actions.dart';
import '../../../business_Logic/models/CustomUser.dart';
import '../../../business_Logic/models/Job.dart';

class BuildApplicantsList extends StatefulWidget {
  const BuildApplicantsList({super.key, required this.job});

  final Job job;

  @override
  State<BuildApplicantsList> createState() => _BuildApplicantsListState();
}

class _BuildApplicantsListState extends State<BuildApplicantsList> {

  late List<bool> appliedUserChosen;
  late List<bool> approvedUserChosen;

  @override
  void initState() {
    // init a boolesn list in the same size as the uids list to false
    appliedUserChosen = List.filled(widget.job.signedWorkers.length, false);
    approvedUserChosen = List.filled(widget.job.approvedWorkers.length, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        const Text(
          "Applicants",
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // add separator
        Container(
          height: 0.5,
          width: double.infinity,
          color: Colors.black12,
          margin: const EdgeInsets.symmetric(vertical: 5),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text(
              "Wait list",
              style: TextStyle(
                  fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "Approved",
              style: TextStyle(
                  fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // make sure the widgets doesn't overflow
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: appliedUserChosen.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<List<CustomUser>>(
                    future: JobsActions().getUsersFromUid(widget.job.signedWorkers),
                    builder: (context, AsyncSnapshot<List<CustomUser>> snapshot) {
                      if (snapshot.hasData) {
                        var applicantApplied = snapshot.data;
                        if (applicantApplied!.length > 0) {
                          return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: -1),
                              leading: CircleAvatar(
                                backgroundImage:
                                NetworkImage(applicantApplied![index].profileImageURL),
                                radius: 13,
                              ),
                              title: Text(applicantApplied[index].username),
                              // subtitle: Text(applicantApplied[index].email),
                              trailing: IconButton(
                                  onPressed: () => setState(() {
                                    // if userChosen[index] is true open a dialog to ask the employer if he wants to remove the user from the job
                                    if (appliedUserChosen[index]) {
                                      removePopup(applicantApplied[index], index);
                                      //TODO: implement the move user from applied to approved list
                                      //move the user from the applied list to the approved list, and add the user to the job
                                      // JobsActions().moveUserFromAppliedToApproved(widget.job, applicantApplied[index].uid);
                                    } else {
                                      if (widget.job.amountNeeded > widget.job.approvedWorkers.length) {
                                        // if userChosen[index] is false and the job is not full add the user to the job
                                        addPopup(applicantApplied[index], index);
                                      } else {
                                        // if the job is full show a dialog to the employer
                                        fullPopup();
                                      }
                                    }
                                  }),
                                  icon: Icon(
                                    Icons.check,
                                    size: 30,
                                    color: appliedUserChosen[index] ? Colors.green : Colors.grey,)
                              ),
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ProfileScreen(user: applicantApplied[index],)
                              ))
                          );
                        } else {
                          return const Center(
                            child: Text("No applicants yet"),
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.5,
              indent: 10,
              endIndent: 10,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: approvedUserChosen.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<List<CustomUser>>(
                    future: JobsActions().getUsersFromUid(widget.job.approvedWorkers),
                    builder: (context, AsyncSnapshot<List<CustomUser>> snapshot) {
                      if (snapshot.hasData) {
                        var applicantApproved = snapshot.data;
                        if (applicantApproved!.length > 0) {
                          return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: -1),
                              leading: CircleAvatar(
                                backgroundImage:
                                NetworkImage(applicantApproved![index].profileImageURL),
                                radius: 13,
                              ),
                              title: Text(applicantApproved[index].username),
                              // subtitle: Text(applicantApproved[index].email),
                              trailing: IconButton(
                                  onPressed: () => setState(() {
                                    // if userChosen[index] is true open a dialog to ask the employer if he wants to remove the user from the job
                                    if (approvedUserChosen[index]) {
                                      removePopup(applicantApproved[index], index);
                                      //TODO: implement the move user from approved to applied list
                                      //move the user from the approved list to the applied list, and remove the user from the job
                                      // JobsActions().removeUserFromApproved(widget.job, applicantApproved[index].uid);
                                    } else {
                                      // if userChosen[index] is false open a dialog to ask the employer if he wants to add the user to the job
                                      addPopup(applicantApproved[index], index);
                                    }
                                  }),
                                  //TODO: finish the logic of the button - add the worker to the job
                                  // JobsActions().hireWorker(widget.job, applicant[index].uid);
                                  icon: Icon(
                                    Icons.check,
                                    size: 30,
                                    color: approvedUserChosen[index] ? Colors.green : Colors.grey,)
                              ),
                              //TODO: change the navigate to a profile card pop up
                              onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ProfileScreen(user: applicantApproved[index],)
                              ))
                          );
                        } else {
                          return const Center(
                            child: Text("No applicants yet"),
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  //TODO: implement this better or different, there is too much code duplication
  Future removePopup(CustomUser user, int index) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Remove User",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),),
          content: const Text(
              "Are you sure you want to remove this user from the job?"),
          actions: [
            TextButton(
              onPressed: () async {
                // if the user is connected to the internet remove the user from the job
                var connectivityResult =
                await (Connectivity().checkConnectivity());
                if (connectivityResult != ConnectivityResult.none) {
                  // TODO: build the logic of the remove worker from job
                  // JobsActions().removeUserFromJob(widget.job, user);
                  setState(() {
                    appliedUserChosen[index] = false;
                  });
                  Navigator.pop(context);
                } else {
                  // if the user is not connected to the internet show a dialog to tell him that he is not connected to the internet
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Error"),
                        content: const Text(
                            "You are not connected to the internet"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  Future addPopup(CustomUser user, int index) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add User",
          style: TextStyle(
              color: Colors.black,
           fontWeight: FontWeight.bold),),
          content: const Text(
              "Are you sure you want to add this user to the job?"),
          actions: [
            TextButton(
              onPressed: () async {
                // if the user is connected to the internet remove the user from the job
                var connectivityResult =
                await (Connectivity().checkConnectivity());
                if (connectivityResult != ConnectivityResult.none) {
                  // TODO: build the logic of the adding worker from job
                  // JobsActions().addUserToJob(widget.job, user);
                  setState(() {
                    appliedUserChosen[index] = true;
                  });
                  Navigator.pop(context);
                } else {
                  // if the user is not connected to the internet show a dialog to tell him that he is not connected to the internet
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Error"),
                        content: const Text(
                            "You are not connected to the internet"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  void fullPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text(
              "You can't add more workers to the job"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}

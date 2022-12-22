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

  late List<bool> userChosen;

  @override
  void initState() {
    // init a boolesn list in the same size as the uids list to false
    userChosen = List.filled(widget.job.signedWorkers.length, false);
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
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.job.signedWorkers.length,
          itemBuilder: (context, index) {
            return FutureBuilder<List<CustomUser>>(
              future: JobsActions().getUsersFromUid(widget.job.signedWorkers),
              builder: (context, AsyncSnapshot<List<CustomUser>> snapshot) {
                if (snapshot.hasData) {
                  var applicant = snapshot.data;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(applicant![index].profileImageURL),
                    ),
                    title: Text(applicant[index].username),
                    subtitle: Text(applicant[index].email),
                    trailing: IconButton(
                      onPressed: () => setState(() {
                        // if userChosen[index] is true open a dialog to ask the employer if he wants to remove the user from the job
                        if (userChosen[index]) {
                          removePopup(applicant[index], index);
                        } else {
                          // if userChosen[index] is false open a dialog to ask the employer if he wants to add the user to the job
                          addPopup(applicant[index], index);
                        }
                      }),
                          //TODO: finish the logic of the button - add the worker to the job
                          // JobsActions().hireWorker(widget.job, applicant[index].uid);
                      icon: Icon(
                          Icons.check,
                          size: 30,
                          color: userChosen[index] ? Colors.green : Colors.grey,)
                        ),
                    //TODO: change the navigate to a profile card pop up
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: applicant[index],)
                    ))
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ),
      ],
    );
  }

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
                    userChosen[index] = false;
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
                    userChosen[index] = true;
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
}

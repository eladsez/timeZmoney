import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/profile/profile_screen.dart';

import '../../../business_Logic/actions/jobs_actions.dart';
import '../../../business_Logic/models/CustomUser.dart';
import '../../../business_Logic/models/Job.dart';

class BuildApplicantsList extends StatefulWidget {
   BuildApplicantsList({super.key, required this.job});

  late final Job job;

  @override
  State<BuildApplicantsList> createState() => _BuildApplicantsListState();
}

class _BuildApplicantsListState extends State<BuildApplicantsList> {

  late List<bool> appliedUserChosen;
  late List<bool> approvedUserChosen;
  late int currIndex;

  @override
  void initState() {
    // init a boolesn list in the same size as the uids list to false
    appliedUserChosen = List.filled(widget.job.signedWorkers.length, false);
    approvedUserChosen = List.filled(widget.job.approvedWorkers.length, true);
    currIndex = 0;
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
            // wait list
            buildListOfApplicants(true),
            const Divider(
              color: Colors.black,
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
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.41),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: isApplied ? appliedUserChosen.length : approvedUserChosen.length,
        itemBuilder: (context, index) {
          return FutureBuilder<List<CustomUser>>(
            future: isApplied
                ? JobsActions().getUsersFromUid(widget.job.signedWorkers)
                : JobsActions().getUsersFromUid(widget.job.approvedWorkers),
            builder: (context, AsyncSnapshot<List<CustomUser>> snapshot) {
              if (snapshot.hasData) {
                var applicants = snapshot.data;
                if (applicants!.length > 0) {
                  currIndex = index;
                  return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: -1),
                      leading: CircleAvatar(
                        backgroundImage:
                        NetworkImage(applicants![currIndex].profileImageURL),
                        radius: 13,
                      ),
                      title: Text(applicants[currIndex].username, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis,),
                      // subtitle: Text(applicantApplied[index].email),
                      trailing: IconButton(
                          onPressed: () => setState(() {
                            if (widget.job.amountNeeded > widget.job.approvedWorkers.length) {
                              if (isApplied) {
                                applicantsApprovalPopup(applicants[currIndex], currIndex, true);
                              } else {
                                applicantsApprovalPopup(applicants[currIndex], currIndex, false);
                              }
                            } else {
                              fullPopup();
                            }
                          }),
                          icon: Icon(
                            Icons.check,
                            size: 25,
                            color: appliedUserChosen[currIndex] ? Colors.green : Colors.grey,)
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: applicants[currIndex],)
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
    );
  }



  //TODO: implement this better or different, there is too much code duplication
  Future applicantsApprovalPopup(CustomUser user, int index, bool isApplied) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: isApplied ? const Text("Approve User",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),) : const Text("Remove User",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold),),
          content: isApplied ? const Text(
              "Are you sure you want to add this user to the job?") : const Text(
              "Are you sure you want to remove this user from the job?"),
          actions: [
            TextButton(
              onPressed: () async {
                // check if the user is connected to the internet
                var connectivityResult =
                await (Connectivity().checkConnectivity());
                if (connectivityResult != ConnectivityResult.none) {
                  isApplied ? JobsActions().approveUserToJob(widget.job, user.uid) : JobsActions().removeUserFromJob(widget.job, user.uid);
                  setState(() {
                    // get the updated job from the database
                    JobsActions().getJobByUid(widget.job.uid).then((value) {
                      widget.job = value!;
                      // update the lists
                      appliedUserChosen = List.filled(widget.job.signedWorkers.length, false);
                      approvedUserChosen = List.filled(widget.job.approvedWorkers.length, true);
                      // update the index
                      currIndex = isApplied ? widget.job.signedWorkers.indexOf(user.uid) : widget.job.approvedWorkers.indexOf(user.uid);
                    });
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

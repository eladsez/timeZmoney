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

  @override
  Widget build(BuildContext context) {
    List uids = widget.job.signedWorkers;
    // init a boolesn list in the same size as the uids list to false
    List<bool> taped = List.filled(uids.length, false);
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
              future: JobsActions().getUsersFromUid(uids),
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
                        taped[index] = !(taped[index]);
                      }),
                          //TODO: finish the logic of the button - add the worker to the job
                          // JobsActions().hireWorker(widget.job, applicant[index].uid);
                      icon: Icon(
                          Icons.check,
                          size: 30,
                          // TODO: change color to green if tapped
                          color: taped[index] ? Colors.green : Colors.grey,)
                        ),
                    //TODO: change the navigate to a profile card pop up
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const ProfileScreen()
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
}

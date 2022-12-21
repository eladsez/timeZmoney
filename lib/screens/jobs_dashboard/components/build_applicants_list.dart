import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

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
  Future<bool> _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List uids = widget.job.signedWorkers;
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
                    title: Text(applicant![index].username),
                    subtitle: Text(applicant![index].email),
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

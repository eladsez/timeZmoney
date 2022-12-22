import 'package:flutter/material.dart';
import '../../../business_Logic/actions/jobs_actions.dart';
import '../../../business_Logic/models/Job.dart';

class ApplyToJob extends StatefulWidget {
  const ApplyToJob({super.key, required this.job, required this.userUid});

  final Job job;
  final String userUid;

  @override
  State<ApplyToJob> createState() => _ApplyToJobState();
}

class _ApplyToJobState extends State<ApplyToJob> {
  JobsActions actions = JobsActions();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 50,
        ),
        // add separator
        Container(height: 0),
        ElevatedButton(
            onPressed: () async {
              // check if the user already applied to the job
              if (widget.job.signedWorkers.contains(widget.userUid)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("You have already applied to this job!"),
                  backgroundColor: Colors.red,
                  duration: Duration(milliseconds: 1500),
                ));
              } else {
                // add the user to the job applicants list
                try {
                  await actions.addUserToWaitList(widget.job);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("You have applied to this job successfully!"),
                    backgroundColor: Colors.green,
                    duration: Duration(milliseconds: 1500),
                  ));
                  // catch any errors that might occur while adding the user to the job applicants list
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("An error has occurred, please try again later."),
                    backgroundColor: Colors.red,
                    duration: Duration(milliseconds: 1500),
                  ));
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade400,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            child: const Text("Click to Apply")),
      ],
    );
  }
}

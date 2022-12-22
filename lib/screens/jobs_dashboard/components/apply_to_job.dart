import 'package:flutter/material.dart';

import '../../../business_Logic/actions/jobs_actions.dart';
import '../../../business_Logic/models/Job.dart';

class ApplyToJob extends StatefulWidget{
  const ApplyToJob({super.key, required this.job});

  final Job job;

  @override
  State<ApplyToJob> createState() => _ApplyToJobState();
}

class _ApplyToJobState extends State<ApplyToJob>{

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
        Container(
          height: 0
        ),
        ElevatedButton(
          onPressed: () async {
            try{
              await actions.addUserToWaitList(widget.job);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("You have applied to this job")));}
            catch(e){
              print(e);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            )
          ),
            child: const Text("Click to Apply")),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../business_Logic/models/Job.dart';

class ApplyToJob extends StatefulWidget{
  const ApplyToJob({super.key, required this.job});

  final Job job;

  @override
  State<ApplyToJob> createState() => _ApplyToJobState();
}

class _ApplyToJobState extends State<ApplyToJob>{


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
        ElevatedButton(onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purpleAccent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            )
          ),
            child: const Text("Click to Apply")),
      ],
    );
  }
}

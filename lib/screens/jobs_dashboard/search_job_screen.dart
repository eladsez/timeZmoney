import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/job_details.dart';

import '../../business_Logic/actions/jobs_actions.dart';
import '../upload_job/Component/inputfiled.dart';

class SearchJobScreen extends StatefulWidget {
  const SearchJobScreen({Key? key}) : super(key: key);

  @override
  State<SearchJobScreen> createState() => _SearchJobScreen();
}

class _SearchJobScreen extends State<SearchJobScreen> {
  final JobsActions jobsActions = JobsActions();
  late final TextEditingController searchController;
  String selectedJob = "Choose job here...";

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 0.5),
                      child: Text(
                        'Are you looking for a job ?',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    FutureBuilder(
                      future: jobsActions.getAllJobs(),
                      builder: (context, jobsSnap) => InputField(
                        title: '',
                        hint: selectedJob,
                        child: DropdownButton(
                          onChanged: (String? newJob) {
                            setState(() {
                              selectedJob = newJob!;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) =>JobDetails(
                              job: jobsSnap.data!.firstWhere((element) => element.title == newJob),
                              )));
                            });
                          },
                          items: jobsSnap.data != null
                              ? jobsSnap.data!
                              .map<DropdownMenuItem<String>>(
                                (job) => DropdownMenuItem<String>(
                              value: job.title,
                              child: Text(job.title),
                            ),
                          )
                              .toList()
                              : [const DropdownMenuItem<String>(child: Text(" "))],
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 32,
                            color: Colors.grey,
                          ),
                          elevation: 3,
                          underline: Container(height: 0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    // TextFormField(
                    //   style: const TextStyle(),
                    //   decoration: const InputDecoration(
                    //     hintText: 'Enter job here...',
                    //     prefixIcon: Icon(Icons.search),
                    //   ),
                    // ),
                  ],
                ))));
  }

  AppBar appBar() {
    return AppBar(
      toolbarHeight: 70,
      title: const Center(
          child: Text(
        'Search Job',
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
      )),
      shadowColor: Colors.black.withOpacity(0.4),
      bottomOpacity: 0.9,
      backgroundColor: Colors.white,
    );
  }
}

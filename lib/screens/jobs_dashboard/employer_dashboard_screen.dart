import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/job_details.dart';

import '../../business_Logic/actions/jobs_actions.dart';
import '../../business_Logic/models/Job.dart';
import '../Loading_Screens/loading_screen.dart';

class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<EmployerDashboardScreen> createState() =>
      _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState extends State<EmployerDashboardScreen> {
  late final PageController pageController; // for jobs dashboard
  late final ScrollController scrollController; // for major tabs
  final jobsActions = JobsActions();
  int selectedMajorIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cardSpace = const SizedBox(
      height: 6,
    );
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: jobsActions.getEmployerJobs(),
              builder: (context, AsyncSnapshot<List<Job>> snapshot) {
                if (snapshot.hasData) {
                  var job = snapshot.data;
                  return ListView.builder(
                    itemCount: job!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        width: MediaQuery.of(context)
                            .size
                            .width *
                            0.4,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(30),
                            color: Theme.of(context)
                                .scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset:
                                  const Offset(0, 1))
                            ]),
                        child: OpenContainer(
                          closedElevation: 0,
                          middleColor: Colors.white,
                          closedColor: Colors.transparent,
                          closedBuilder: (context, action) => Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  job[index].imageUrl != "None" ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                        height: 80,
                                        width: 140,
                                        fit: BoxFit.cover,
                                        image: ResizeImage(
                                            NetworkImage(job[index].imageUrl),
                                            height: 110,
                                            width: 140)),
                                  ) : Container(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      job[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  cardSpace,
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.black45),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Text(
                                          job[index].district,
                                          style: const TextStyle(
                                              color: Colors.black45),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                    ],
                                  ),
                                  cardSpace,
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.attach_money,
                                        color: Colors.black45,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Text(
                                          job[index].salary.toString(),
                                          style: const TextStyle(
                                              color: Colors.black45),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                  cardSpace,
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.date_range,
                                        color: Colors.black45,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        job[index].date
                                            .toDate()
                                            .toString()
                                            .split(" ")[0],
                                        style: const TextStyle(
                                            color: Colors.black45),
                                      )
                                    ],
                                  ),

                                ],
                              ),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // progress bar that shows the number of applicants that have been approved
                                  const Text('Approved:'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Stack(
                                    children: [
                                      CircularProgressIndicator(
                                        value: job[index].approvedWorkers.length / job[index].amountNeeded,
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                        backgroundColor: Colors.grey,
                                      ),
                                      // position the label in the middle of the progress indicator
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${job[index].approvedWorkers.length}/${job[index].amountNeeded}',
                                            style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),



                                ],
                              )
                            ],
                          ),
                          openBuilder: (context, action) =>
                              JobDetails(job: job[index]),
                        ),
                      );
                    }
                  );
                } else {
                  return const Loading();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

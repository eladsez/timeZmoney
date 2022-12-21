import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/job_details.dart';

import '../../business_Logic/actions/jobs_actions.dart';
import '../../business_Logic/models/Job.dart';

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
                    itemBuilder: (contex, index) {
                      return OpenContainer(
                        closedShape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        closedElevation: 0,
                        middleColor: Colors.white,
                        closedColor: Colors.transparent,
                        closedBuilder: (context, action) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                  height: 80,
                                  width: 140,
                                  fit: BoxFit.cover,
                                  image: ResizeImage(
                                      NetworkImage(job![index].imageUrl),
                                      height: 110,
                                      width: 140)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              job![index].title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            cardSpace,
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.black45),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  job![index].district,
                                  style: const TextStyle(
                                      color: Colors.black45),
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
                                Text(
                                  job![index].salary.toString(),
                                  style: const TextStyle(
                                      color: Colors.black45),
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
                                  job![index].date
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
                        openBuilder: (context, action) =>
                            JobDetails(job: snapshot.data![0]),
                      );
                    }
                  );


                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/fade_effect.dart';
import 'package:flutter_animate/effects/slide_effect.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/job_details.dart';
import '../../business_Logic/actions/jobs_actions.dart';
import '../Loading_Screens/loading_screen.dart';

class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<EmployerDashboardScreen> createState() => _EmployerDashboardScreenState();
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
              future: jobsActions.getJobsMajors(),
              builder: (context, jobsMajorsSnap) => PageView(
                physics: const BouncingScrollPhysics(),
                controller: pageController,
                onPageChanged: ((value) => setState(() {selectedMajorIndex = value;})),
                children: jobsMajorsSnap.data != null
                    ? jobsMajorsSnap.data!
                    .map(
                      (e) => FutureBuilder(
                    future: jobsActions.getJobsOfTab(jobsMajorsSnap.data![selectedMajorIndex]),
                    builder: (context, jobsListSnap) => GridView.count(
                      childAspectRatio: 1.5,
                      controller:
                      ScrollController(keepScrollOffset: false),
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 1,
                      children: jobsListSnap.data != null
                          ? jobsListSnap.data!
                          .map(
                            (job) => Animate(
                          effects: const [
                            FadeEffect(),
                            SlideEffect(
                                duration:
                                Duration(milliseconds: 200))
                          ],
                          child: Container(
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
                                closedBuilder: (context,
                                    action) =>
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius
                                              .circular(15),
                                          child: Image(
                                              height: 80,
                                              width: 140,
                                              fit: BoxFit.cover,
                                              image: ResizeImage(
                                                  NetworkImage(job
                                                      .imageUrl),
                                                  height: 110,
                                                  width: 140)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          job.title,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        ),
                                        cardSpace,
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons
                                                    .location_on,
                                                color: Colors
                                                    .black45),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              job.district,
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black45),
                                            ),
                                          ],
                                        ),
                                        cardSpace,
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .attach_money,
                                              color: Colors
                                                  .black45,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              job.salary
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black45),
                                            )
                                          ],
                                        ),
                                        cardSpace,
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.date_range,
                                              color: Colors
                                                  .black45,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              job.date
                                                  .toDate()
                                                  .toString()
                                                  .split(
                                                  " ")[0],
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black45),
                                            )
                                          ],
                                        ),
                                        // Center(
                                        //   child: ElevatedButton(
                                        //     style: ElevatedButton
                                        //         .styleFrom(
                                        //       backgroundColor:
                                        //           const Color(
                                        //               0xff01b2b8),
                                        //       shape:
                                        //           const CircleBorder(),
                                        //     ),
                                        //     onPressed: () {},
                                        //     // TODO: add map logic
                                        //     child: const Icon(
                                        //         Icons.directions),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                openBuilder:
                                    (context, action) =>
                                    JobDetails(job: job)),
                          ),
                        ),
                      )
                          .toList()
                          : [const Loading()],
                    ),
                  ),
                )
                    .toList()
                    : [const Loading()],
              ),
            ),
          )
        ],
      ),
    );
  }
}

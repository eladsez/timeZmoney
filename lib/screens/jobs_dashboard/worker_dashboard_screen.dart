import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/fade_effect.dart';
import 'package:flutter_animate/effects/slide_effect.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/job_details.dart';

import '../../business_Logic/actions/jobs_actions.dart';
import '../../utils/helper_functions.dart';
import '../../utils/theme.dart';
import '../Loading_Screens/loading_screen.dart';

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
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

  /*
  * This function build the major tabs, also the transfer logic between them
  */
  Widget buildMajorTabs() {
    return FutureBuilder(
        future: jobsActions.getJobsMajors(),
        builder: (context, majorsListSnap) => Container(
              decoration: BoxDecoration(
                color: theme.backgroundColor,
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                children: majorsListSnap.data != null
                    ? majorsListSnap.data!
                        .map((tab) => GestureDetector(
                              onTap: () {
                                if (majorsListSnap.data!.indexOf(tab) > 1 &&
                                    selectedMajorIndex <
                                        majorsListSnap.data!.indexOf(tab)) {
                                  scrollController.animateTo(200,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.ease);
                                }
                                setState(() {
                                  selectedMajorIndex =
                                      majorsListSnap.data!.indexOf(tab);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: selectedMajorIndex ==
                                          majorsListSnap.data!.indexOf(tab)
                                      ? theme.accentColor
                                      : theme.cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 1,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 1)),
                                  ],
                                ),
                                child: Text(
                                  tab,
                                  style: TextStyle(
                                      color: selectedMajorIndex ==
                                              majorsListSnap.data!.indexOf(tab)
                                          ? Colors.white70
                                          : theme.secondaryIconColor),
                                ),
                              ),
                            ))
                        .toList()
                    : [],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var cardSpace = const SizedBox(
      height: 6,
    );
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundColor,
        ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ],
              ),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: buildMajorTabs(),
            ),
            Expanded(
              child: FutureBuilder(
                future: jobsActions.getJobsMajors(),
                builder: (context, jobsMajorsSnap) => PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: ((value) => setState(() {
                        selectedMajorIndex = value;
                      })),
                  children: jobsMajorsSnap.data != null
                      ? jobsMajorsSnap.data!
                          .map(
                            (e) => FutureBuilder(
                              future: jobsActions.getJobsOfTab(
                                  jobsMajorsSnap.data![selectedMajorIndex]),
                              builder: (context, jobsListSnap) =>
                                  GridView.count(
                                childAspectRatio: 0.7,
                                controller:
                                    ScrollController(keepScrollOffset: false),
                                physics: const BouncingScrollPhysics(),
                                crossAxisCount: 2,
                                children: jobsListSnap.data != null
                                    ? jobsListSnap.data!
                                        .map(
                                          (job) => Animate(
                                            effects: const [
                                              FadeEffect(),
                                              SlideEffect(
                                                  duration: Duration(
                                                      milliseconds: 200))
                                            ],
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  // color: Theme.of(context).scaffoldBackgroundColor,
                                                  color: theme.cardColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        blurRadius: 10,
                                                        spreadRadius: 0,
                                                        offset:
                                                            const Offset(0, 1))
                                                  ]),
                                              child: OpenContainer(
                                                  closedElevation: 0,
                                                  middleColor: Colors.white,
                                                  closedColor:
                                                      Colors.transparent,
                                                  closedBuilder:
                                                      (context, action) =>
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              job.imageUrl !=
                                                                      "None"
                                                                  ? ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      child: Image(
                                                                          height:
                                                                              80,
                                                                          width:
                                                                              140,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image: ResizeImage(
                                                                              NetworkImage(job.imageUrl),
                                                                              height: 110,
                                                                              width: 140)),
                                                                    )
                                                                  : SizedBox(
                                                                      height:
                                                                          83,
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            "Employer didn't provide image",
                                                                            style:
                                                                                TextStyle(color: theme.textFieldTextColor)),
                                                                      ),
                                                                    ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                job.title,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: theme
                                                                        .titleColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              cardSpace,
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      color: theme
                                                                          .secondaryIconColor),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Flexible(
                                                                      child:
                                                                          Text(
                                                                    job.district,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        color: theme
                                                                            .secondaryIconColor),
                                                                  )),
                                                                ],
                                                              ),
                                                              cardSpace,
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .attach_money,
                                                                    color: theme
                                                                        .secondaryIconColor,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.2,
                                                                    child: Text(
                                                                      "${job.salary} per ${job.per}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              theme.secondaryIconColor),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              cardSpace,
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .date_range,
                                                                    color: theme
                                                                        .secondaryIconColor,
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
                                                                    style: TextStyle(
                                                                        color: theme
                                                                            .secondaryIconColor),
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
                                                      (context, action) {
                                                    return JobDetails(job: job);
                                                  }),
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
      ),
    );
  }
}

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/models/CustomUser.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/job_details.dart';

import '../../../business_Logic/actions/jobs_actions.dart';
import '../../../business_Logic/models/Job.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';
import '../../Loading_Screens/loading_screen.dart';


class JobListViewer extends StatefulWidget {
  const JobListViewer({Key? key,required this.user,required this.kind}) : super(key: key);
  final CustomUser user;
  final String kind;
  @override
  State<JobListViewer> createState() =>
      _JobListViewerState();
}

class _JobListViewerState extends State<JobListViewer> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  late final PageController pageController; // for jobs dashboard
  final jobsActions = JobsActions();

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cardSpace = const SizedBox(
      height: 6,
    );
    return Material(
      child: Container(
        color: theme.backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: widget.user.userType?.compareTo("employer") == 0? (widget.kind.compareTo("future") == 0? jobsActions.getFutureJobsCreated(widget.user): jobsActions.getPastJobsCreated(widget.user)):(widget.kind.compareTo("future") == 0? jobsActions.getFutureJobsApproved(widget.user): jobsActions.getPastJobsApproved(widget.user)),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: theme.titleColor),
                                        ),
                                      ),
                                      cardSpace,
                                      Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: theme.secondaryIconColor),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: Text(
                                              job[index].district,
                                              style: TextStyle(
                                                  color: theme.secondaryIconColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      cardSpace,
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.attach_money,
                                            color: theme.secondaryIconColor,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: Text(
                                              "${job[index].salary} per ${job[index].per}",
                                              style: TextStyle(
                                                  color: theme.secondaryIconColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                      cardSpace,
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.date_range,
                                            color: theme.secondaryIconColor,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            job[index].date
                                                .toDate()
                                                .toString()
                                                .split(" ")[0],
                                            style: TextStyle(
                                                color: theme.secondaryIconColor),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  job[index].employerUid != widget.user.uid ? Container() :
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // progress bar that shows the number of applicants that have been approved
                                      Text('Approved:', style: TextStyle(color: theme.textFieldTextColor),),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Stack(
                                        children: [
                                          CircularProgressIndicator(
                                            value: job[index].approvedWorkers.length / job[index].amountNeeded,
                                            valueColor: AlwaysStoppedAnimation<Color?>(theme.accentColor),
                                            backgroundColor: Colors.grey,
                                          ),
                                          // position the label in the middle of the progress indicator
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${job[index].approvedWorkers.length}/${job[index].amountNeeded}',
                                                style: TextStyle(color: theme.secondaryIconColor, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}

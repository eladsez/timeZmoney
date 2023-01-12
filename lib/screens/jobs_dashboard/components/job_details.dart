import 'dart:core';
import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/actions/user_actions.dart';
import 'package:time_z_money/business_Logic/models/CustomUser.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/apply_to_job.dart';
import '../../../business_Logic/actions/auth_actions.dart';
import '../../../business_Logic/models/Job.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';
import '../../maps/direction_map.dart';
import '../../profile/profile_screen.dart';
import 'build_applicants_list.dart';
import 'coWorkers.dart';

class JobDetails extends StatefulWidget {
  JobDetails({super.key, required this.job});

  final Job job;

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();

  // the employer of the job
  late CustomUser employer;
  UserActions userActions = UserActions();

  // init the employer
  @override
  void initState() {
    super.initState();
    Future<CustomUser?> tmp = userActions
        .getUserByUid(widget.job.employerUid)
        .then((value) => employer = value!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: theme.appBarColor,
                  elevation: theme.elevation,
                  leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_back,
                          color: theme.backArrowColor,
                        )),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height * 0.45,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1.6,
                    centerTitle: true,
                    titlePadding: const EdgeInsets.all(20),
                    title: Text(
                      widget.job.title.toUpperCase(),
                      style: TextStyle(
                        color: theme.titleColor,
                        fontSize: 14,
                        letterSpacing: 1.8,
                        shadows: const [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                    background: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height + 200));
                      },
                      blendMode: BlendMode.dst,
                      child: widget.job.imageUrl != "None"
                          ? Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(widget.job.imageUrl))
                          : Container(),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Wrap(
                        spacing: -10,
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // if the user is the employer of the job, don't show the profile button
                          widget.job.employerUid != AuthActions.currUser!.uid
                              ? IconButton(
                                  icon: Icon(Icons.person,
                                      color: theme.backArrowColor),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                                  user: employer,
                                                )));
                                  },
                                )
                              : Container(),
                          widget.job.employerUid != AuthActions.currUser!.uid
                              ? Text('Employer',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: theme.backArrowColor))
                              : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: theme.secondaryIconColor,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          widget.job.district,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme.secondaryIconColor, fontSize: 16),
                        ),
                      ),
                      const Spacer(),
                      // direction button that will be used to navigate to the map screen
                      // to show the location of the job
                      AuthActions.currUser.uid != widget.job.employerUid
                          ? GestureDetector(
                              onTap: () {
                                // TODO: navigate to the map screen
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MapDirection(
                                          dest: widget.job.location,
                                        )));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 7, bottom: 7),
                                decoration: BoxDecoration(
                                  color: theme.accentColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.directions,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      'Direction',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  // the job detail line
                  const SizedBox(
                    height: 10,
                  ),
                  jobDetailLine(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.job.description,
                    style: TextStyle(
                        fontSize: 18, color: theme.textFieldTextColor),
                  ),
                  // if the current user is an employer, show a list of workers who applied for this job
                  AuthActions.currUser.userType == "worker"
                      ? (widget.job.approvedWorkers
                              .contains(AuthActions.currUser.uid)
                          ? CoWorkersList(job: widget.job)
                          : ApplyToJob(job: widget.job))
                      : AuthActions.currUser.uid == widget.job.employerUid
                          ? BuildApplicantsList(job: widget.job)
                          : Container(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          )),
    );
  }

// returns the ditals of the job
  Widget jobDetailLine() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                  widget.job.date.toDate().toString().split(" ")[0],
                  style: TextStyle(color: theme.secondaryIconColor),
                )
              ],
            ),
            buildDivider(),
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: theme.secondaryIconColor,
                ),
                Text(
                  "${widget.job.salary} per ${widget.job.per}",
                  style: TextStyle(color: theme.secondaryIconColor),
                )
              ],
            ),
            buildDivider(),
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: theme.secondaryIconColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.job.amountNeeded.toString(),
                  style: TextStyle(color: theme.secondaryIconColor),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() => SizedBox(
        height: 24,
        child: VerticalDivider(
          color: theme.secondaryIconColor,
          thickness: 1,
        ),
      );
}

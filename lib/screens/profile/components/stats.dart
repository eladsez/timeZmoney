import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/actions/jobs_actions.dart';
import 'package:time_z_money/business_Logic/actions/review_actions.dart';
import 'package:time_z_money/business_Logic/actions/user_actions.dart';
import 'package:time_z_money/business_Logic/models/CustomUser.dart';
import 'package:time_z_money/business_Logic/models/Review.dart';
import 'package:time_z_money/screens/profile/components/xpopup/appbar.dart';
import 'package:time_z_money/screens/profile/components/xpopup/card.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../business_Logic/models/Job.dart';
import '../../../utils/theme.dart';
import '../../Loading_Screens/loading_screen.dart';
import '../../jobs_dashboard/components/job_details.dart';

class Stats extends StatefulWidget {
  const Stats({super.key, required this.user, required this.theme});

  final CustomUser user;
  final AppTheme theme;

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  JobsActions jobsActions = JobsActions();
  ReviewActions reviewActions = ReviewActions();
  UserActions userActions = UserActions();

  List usernames = []; // the usernames of the currUser's reviews
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<String> uids = [];
    reviewActions.getReviewsOnUser(widget.user).then((value) {
      for (var review in value) {
        uids.add(review.writer);
      }
      userActions.getUsersFromUid(uids).then((value) {
        setState(() {
          for (var user in value) {
            usernames.add(user.username);
          }
        });
      });
     });
  }


  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder(
              future: reviewActions.getReviewsOnUser(widget.user),
              builder: (context, AsyncSnapshot<List<JobReview>> snapshot) {
                if (snapshot.hasData) {
                  List<JobReview> reviews = snapshot.data ?? [];
                  if (reviews.isEmpty) {
                    return buildPopUp("future", "Reviews", 0);
                    // return buildButton(context, "Reviews", 0);
                  }
                  double average = reviews.map((review) => review.stars).reduce(
                          (firstStarts, secondStars) =>
                              firstStarts + secondStars) /
                      reviews.length;
                  return buildPopUp("future", "Reviews", average);
                  // return buildButton(context, "Reviews", average);
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          buildDivider(),
          FutureBuilder(
              future: widget.user.userType?.compareTo("employer") == 0
                  ? jobsActions.getFutureJobsCreated(widget.user)
                  : jobsActions.getFutureJobsApproved(widget.user),
              builder: (context, AsyncSnapshot<List<Job>> snapshot) {
                if (snapshot.hasData) {
                  int length = snapshot.data?.length ?? 0;
                  return buildPopUp(
                      "future", "Current Jobs", length.toDouble());
                  // return buildButton(context, "Current Jobs", length.toDouble());
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          buildDivider(),
          FutureBuilder(
              future: widget.user.userType?.compareTo("employer") == 0
                  ? jobsActions.getPastJobsCreated(widget.user)
                  : jobsActions.getPastJobsApproved(widget.user),
              builder: (context, AsyncSnapshot<List<Job>> snapshot) {
                if (snapshot.hasData) {
                  int length = snapshot.data?.length ?? 0;
                  return buildPopUp('past', "Past Jobs", length.toDouble());
                  // return buildButton(context, "Past Jobs", length.toDouble());
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ],
      );

  Widget buildDivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildPopUp(String? kind, String value, double toDisplay) =>
      GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (builder) => StatefulBuilder(builder: (context, setState) {
            return XenPopupCard(
              cardBgColor: widget.theme.cardColor,
              relHeight: 0.17,
              appBar: buildTopBar(value),
              body: value == "Reviews"
                  ? buildReviewsLists(kind!)
                  : buildJobsLists(kind!),
            );
          }),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value.compareTo("Reviews") == 0
                  ? toDisplay.toStringAsFixed(2)
                  : toDisplay.toInt().toString(),
              style: TextStyle(
                  color: widget.theme.textFieldTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                  color: widget.theme.textFieldTextColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  XenCardAppBar buildTopBar(String value) => XenCardAppBar(
        color: widget.theme.appBarColor,
        shadow: const BoxShadow(color: Colors.transparent),
        child: Text(
          value == "Reviews"
              ? "Reviews"
              : value == "Current Jobs"
                  ? "Current Jobs"
                  : "Past Jobs",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: widget.theme.titleColor),
        ),
      );

  Widget buildReviewsLists(String kind) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: reviewActions.getReviewsOnUser(widget.user),
            builder: (context, AsyncSnapshot<List<JobReview>> snapshot) {
              if (snapshot.hasData) {
                var reviews = snapshot.data;
                return ListView.builder(
                    itemCount: reviews!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: widget.theme.cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 1))
                            ]),
                        child: Column(
                          children: [
                            RatingBarIndicator(
                              rating: reviews[index].stars,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            Text(reviews[index].content,
                                style: TextStyle(
                                    color: widget.theme.textFieldTextColor)),
                            Text(usernames[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    color: widget.theme.titleColor))
                          ],
                        ),
                      );
                    });
              } else {
                return const Loading();
              }
            },
          ),
        )
      ],
    );
  }


  Widget buildJobsLists(String kind) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: widget.user.userType?.compareTo("employer") == 0
                ? (kind.compareTo("future") == 0
                    ? jobsActions.getFutureJobsCreated(widget.user)
                    : jobsActions.getPastJobsCreated(widget.user))
                : (kind.compareTo("future") == 0
                    ? jobsActions.getFutureJobsApproved(widget.user)
                    : jobsActions.getPastJobsApproved(widget.user)),
            builder: (context, AsyncSnapshot<List<Job>> snapshot) {
              if (snapshot.hasData) {
                var job = snapshot.data;
                return ListView.builder(
                    itemCount: job!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: widget.theme.cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 1))
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
                                  job[index].imageUrl != "None"
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image(
                                              height: 80,
                                              width: 140,
                                              fit: BoxFit.cover,
                                              image: ResizeImage(
                                                  NetworkImage(
                                                      job[index].imageUrl),
                                                  height: 110,
                                                  width: 140)),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      job[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.theme.titleColor),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color:
                                              widget.theme.secondaryIconColor),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          job[index].district,
                                          style: TextStyle(
                                              color: widget
                                                  .theme.secondaryIconColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.attach_money,
                                        color: widget.theme.secondaryIconColor,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          "${job[index].salary} per ${job[index].per}",
                                          style: TextStyle(
                                              color: widget
                                                  .theme.secondaryIconColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: widget.theme.secondaryIconColor,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        job[index]
                                            .date
                                            .toDate()
                                            .toString()
                                            .split(" ")[0],
                                        style: TextStyle(
                                            color: widget
                                                .theme.secondaryIconColor),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          openBuilder: (context, action) =>
                              JobDetails(job: job[index]),
                        ),
                      );
                    });
              } else {
                return const Loading();
              }
            },
          ),
        )
      ],
    );
  }
}

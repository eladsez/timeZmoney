import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/actions/jobs_actions.dart';
import 'package:time_z_money/business_Logic/actions/review_actions.dart';
import 'package:time_z_money/business_Logic/models/CustomUser.dart';
import 'package:time_z_money/business_Logic/models/Review.dart';
import 'package:time_z_money/screens/profile/components/job_list_view.dart';
import 'package:time_z_money/screens/profile/components/review_list_view.dart';

import '../../../business_Logic/models/Job.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';

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
                    return buildButton(context, "Reviews", 0);
                  }
                  double average = reviews.map((review) => review.stars).reduce(
                          (firstStarts, secondStars) =>
                              firstStarts + secondStars) /
                      reviews.length;
                  return buildButton(context, "Reviews", average);
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
                  return buildButton(
                      context, "Current Jobs", length.toDouble());
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
                  return buildButton(context, "Past Jobs", length.toDouble());
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

  Widget buildButton(BuildContext context, String value, double toDisplay) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () => {
          if (value.compareTo("Past Jobs") == 0)
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          JobListViewer(kind: "past", user: widget.user)))
            }
          else if (value.compareTo("Current Jobs") == 0)
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          JobListViewer(kind: "future", user: widget.user)))
            }
          else
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReviewListViewer(user: widget.user)))
            }
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                  color: widget.theme.textFieldTextColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}

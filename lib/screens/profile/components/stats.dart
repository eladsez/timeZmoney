import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/actions/jobs_actions.dart';
import 'package:time_z_money/business_Logic/actions/review_actions.dart';
import 'package:time_z_money/business_Logic/models/CustomUser.dart';
import 'package:time_z_money/business_Logic/models/Review.dart';

import '../../../business_Logic/models/Job.dart';
import '../../Loading_Screens/loading_screen.dart';

class Stats extends StatefulWidget {
  const Stats(CustomUser user, {super.key});

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
              future: reviewActions.getReviewsOnUser(),
              builder: (context, AsyncSnapshot<List<JobReview>> snapshot) {
                if (snapshot.hasData) {
                  List<JobReview> reviews = snapshot.data ?? [];
                  if(reviews.isEmpty)
                    {
                      return buildButton(context, "Reviews", 0);
                    }
                  double average = reviews.map((review) => review.stars).reduce((firstStarts, secondStars) => firstStarts + secondStars)/reviews.length;
                  return buildButton(context, "Reviews", average);

                } else {
                  return const CircularProgressIndicator();
                }
              }),
          buildDivider(),
          FutureBuilder(
              future: jobsActions.getFutureJobs(),
              builder: (context, AsyncSnapshot<List<Job>> snapshot) {
                if (snapshot.hasData) {
                  int length = snapshot.data?.length ?? 0;
                  return buildButton(context, "Current jobs", length.toDouble());
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          buildDivider(),
          FutureBuilder(
              future: jobsActions.getPastJobs(),
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
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value.compareTo("Reviews") == 0 ? toDisplay.toStringAsFixed(2) : toDisplay.toInt().toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}

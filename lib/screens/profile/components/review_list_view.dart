import 'package:flutter/material.dart';
import 'package:time_z_money/business_Logic/actions/review_actions.dart';
import 'package:time_z_money/business_Logic/models/CustomUser.dart';
import 'package:time_z_money/business_Logic/models/Review.dart';

import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';
import '../../Loading_Screens/loading_screen.dart';


class ReviewListViewer extends StatefulWidget {
  const ReviewListViewer({Key? key,required this.user,}) : super(key: key);
  final CustomUser user;
  @override
  State<ReviewListViewer> createState() =>
      _ReviewListViewerState();
}

class _ReviewListViewerState extends State<ReviewListViewer> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  late final PageController pageController; // for reviews dashboard
  final reviewsActions = ReviewActions();

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
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: reviewsActions.getReviewsOnUser(widget.user),
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
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset:
                                      const Offset(0, 1))
                                ]),
                            child: Column(
                              children: [
                                Text(reviews[index].stars.toString(), style: TextStyle(color: theme.textFieldTextColor),),
                                Text(reviews[index].content, style: TextStyle(color: theme.textFieldTextColor)),
                                Text(reviews[index].writer, style: TextStyle(color: theme.textFieldTextColor))
                              ],
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

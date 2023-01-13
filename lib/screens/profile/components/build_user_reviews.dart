import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:time_z_money/business_Logic/actions/review_actions.dart';
import 'package:time_z_money/screens/profile/components/xpopup/appbar.dart';
import 'package:time_z_money/screens/profile/components/xpopup/card.dart';
import 'package:time_z_money/screens/profile/components/xpopup/gutter.dart';
import '../../../business_Logic/actions/auth_actions.dart';
import '../../../business_Logic/actions/jobs_actions.dart';
import '../../../business_Logic/models/CustomUser.dart';
import '../../../business_Logic/models/Review.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme.dart';
import '../../upload_job/Component/inputfiled.dart';

class BuildUserReviews extends StatefulWidget {
  BuildUserReviews({super.key, required this.user});

  CustomUser user;

  @override
  State<BuildUserReviews> createState() => _BuildUserReviewsState();
}

class _BuildUserReviewsState extends State<BuildUserReviews> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  final JobsActions jobsActions = JobsActions();
  final reviewActions = ReviewActions();
  late TextEditingController reviewController;
  String selectedJobOfReview = 'Job';
  double selectedRate = 3;
  String? selectedJobUid;

  refresh(setState, String newSelect) {
    setState(() {
      selectedJobOfReview = newSelect;
    });
  }

  XenCardAppBar buildReviewBar() =>
      XenCardAppBar(
        shadow: const BoxShadow(color: Colors.transparent),
        child: Text(
          "Post Review",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: theme.titleColor),
        ),
      );

  XenCardGutter buildGutter() =>
      XenCardGutter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              print(reviewController.text);
              print(selectedJobUid);
              if (reviewController.text.isEmpty || selectedJobUid == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("All review filed must be filled"),
                  backgroundColor: Colors.red,
                  duration: Duration(milliseconds: 1500),
                ));
              } else {
                reviewActions.postReview(JobReview(
                    content: reviewController.text,
                    receiver: widget.user.uid!,
                    work: selectedJobUid!,
                    writer: AuthActions.currUser.uid!,
                stars: selectedRate));
              }
              reviewController.text = '';
              selectedJobUid = null;
              selectedRate = 3;
              Navigator.of(context).pop();
            },
            child: Material(
              borderRadius: BorderRadius.circular(5),
              color: theme.accentColor,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Center(
                    child: Text("post",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildForm(setState) {
    return ListView(
      children: [
        // input field for the review
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLines: 5,
            controller: reviewController,
            decoration: InputDecoration(
              hintText: "Write your review here",
              hintStyle: TextStyle(color: theme.secondaryIconColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.black12),
              ),
            ),
          ),
        ),
        FutureBuilder(
          future: jobsActions.getCoOperateJobs(widget.user),
          builder: (context, jobsSnap) =>
              InputField(
                title: "",
                hint: jobsSnap.data != null && jobsSnap.data!.isNotEmpty
                    ? selectedJobOfReview
                    : "Never Cooperate",
                child: DropdownButton(
                  dropdownColor: theme.cardColor,
                  onChanged: (String? newJob) {
                    refresh(setState, newJob!);
                    selectedJobUid = jobsSnap.data
                        ?.singleWhere((job) => job.title == newJob)
                        .uid;
                  },
                  items: jobsSnap.data != null && jobsSnap.data!.isNotEmpty
                      ? jobsSnap.data!
                      .map<DropdownMenuItem<String>>(
                        (job) =>
                        DropdownMenuItem<String>(
                          value: job.title,
                          child: Text(
                            job.title,
                            style: TextStyle(color: theme.textFieldTextColor),
                          ),
                        ),
                  )
                      .toList()
                      : <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                        child: Text("",
                            style:
                            TextStyle(color: theme.textFieldTextColor)))
                  ],
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 32,
                    color: theme.secondaryIconColor,
                  ),
                  elevation: 3,
                  underline: Container(height: 0),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
        ),
        const SizedBox(
          height: 30,
        ),
        Center(
          child: RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
            const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              selectedRate = rating;
            },
          ),
        )
      ],
    );
  }

  Widget postReviewPopUp() =>
      GestureDetector(
        onTap: () =>
            showDialog(
              context: context,
              builder: (builder) =>
                  StatefulBuilder(builder: (context, setState) {
                    return XenPopupCard(
                      relHeight: 0.17,
                      appBar: buildReviewBar(),
                      gutter: buildGutter(),
                      body: buildForm(setState),
                    );
                  }),
            ),
        child: Container(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 7, bottom: 7),
          decoration: BoxDecoration(
            color: theme.accentColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              SizedBox(width: 2),
              Text(
                'Add Review',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void initState() {
    reviewController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 50,
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(children: [
          Text(
            "Reviews",
            style: TextStyle(
                fontSize: 24,
                color: theme.titleColor,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const Spacer(),
          postReviewPopUp(),
        ]),
      ),
      // add separator
      Container(
        height: 0.5,
        width: double.infinity,
        color: Colors.black12,
        margin: const EdgeInsets.symmetric(vertical: 5),
      ),
      ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            //TODO: add the reviews to the firestore so we can get them from there.
            return ListTile(
              // put a dammy review
              title: Text(
                "This is a review",
                style: TextStyle(fontSize: 18, color: theme.textFieldTextColor),
              ),
            );
          }),
    ]);
  }
}

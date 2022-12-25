import 'package:flutter/material.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/apply_to_job.dart';
import '../../../business_Logic/actions/auth_actions.dart';
import '../../../business_Logic/models/Job.dart';
import 'build_applicants_list.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key, required this.job});

  final Job job;

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: const Color(0xff01b2b8),
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xff01b2b8),
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
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.8),
                    ),
                    background: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.white12],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height + 200));
                      },
                      blendMode: BlendMode.dst,
                      child: widget.job.imageUrl != "None" ? Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(widget.job.imageUrl)) : Container(),
                    ),
                  ),
                )
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
                      const Icon(
                        Icons.location_on,
                        color: Colors.black38,
                      ),

                      Text(
                        widget.job.district,
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 16),
                      ),

                      // RatingBar.builder(
                      //   itemSize: 25,
                      //   initialRating: 3,
                      //   minRating: 1,
                      //   direction: Axis.horizontal,
                      //   allowHalfRating: true,
                      //   itemCount: 5,
                      //   itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      //   itemBuilder: (context, _) => const Icon(
                      //     Icons.star,
                      //     color: Colors.amber,
                      //   ),
                      //   onRatingUpdate: (rating) {
                      //     print(rating);
                      //   },
                      // ),
                      // direction button that will be used to navigate to the map screen
                      // to show the location of the job
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          //TODO: navigate to the map screen
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => MapScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xff01b2b8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.directions,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
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

                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.job.description,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  // if the current user is an employer, show a list of workers who applied for this job
                  AuthActions.currUser.userType == "worker"
                      ? ApplyToJob(job: widget.job) : BuildApplicantsList(job: widget.job),
                ],
              ),
            ),
          )
      ),
    );
  }
}

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_z_money/screens/jobs_dashboard/components/job_details.dart';
import '../../business_Logic/actions/jobs_actions.dart';
import '../../business_Logic/models/Job.dart';
import '../../utils/helper_functions.dart';
import '../../utils/theme.dart';
import '../Loading_Screens/loading_screen.dart';

class SearchJobScreen extends StatefulWidget {
  const SearchJobScreen({Key? key}) : super(key: key);

  @override
  State<SearchJobScreen> createState() => _SearchJobScreen();
}

class _SearchJobScreen extends State<SearchJobScreen> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  final JobsActions jobsActions = JobsActions();
  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: theme.backgroundColor,
      body: Column(
        verticalDirection: VerticalDirection.down,
        children: [
          const SizedBox(
            height: 20,
          ),
          searchField(),
          buildSearchList(searchController.text),
        ],
      ),
    );
  }

  Widget searchField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.95,
            height: 52,
            padding: const EdgeInsets.only(left: 8.0),
            margin: const EdgeInsets.only(
              top: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchController.text;
                      });
                    },
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.textFieldTextColor),
                    obscureText: false,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: theme.textFieldTextColor),
                    ),
                    controller: searchController,
                    maxLines: 1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    icon: const Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchList(String search){
    return Expanded(
            child: FutureBuilder(
              future: jobsActions.getRelevantJobsByTitle(search),
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
                                    const SizedBox(
                                      height: 6,
                                    ),
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
                                    const SizedBox(
                                      height: 6,
                                    ),
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
                                    const SizedBox(
                                      height: 6,
                                    ),
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
    );
  }

  AppBar appBar() {
    return AppBar(
      toolbarHeight: 70,
      title: Center(
          child: Text(
        'Search Job',
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, color: theme.titleColor),
      )),
      shadowColor: Colors.black.withOpacity(0.4),
      bottomOpacity: 0.9,
      backgroundColor: theme.appBarColor,
    );
  }
}

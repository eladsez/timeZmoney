import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_z_money/business_Logic/models/Job.dart';

import '../../business_Logic/actions/auth_actions.dart';
import '../../business_Logic/actions/jobs_actions.dart';
import '../../utils/helper_functions.dart';
import '../../utils/theme.dart';
import 'Component/button.dart';
import 'Component/inputfiled.dart';
import 'Component/places_search.dart';

class UploadJobScreen extends StatefulWidget {
  const UploadJobScreen({Key? key}) : super(key: key);

  @override
  State<UploadJobScreen> createState() => _UploadJobScreenState();
}

class _UploadJobScreenState extends State<UploadJobScreen> {
  AppTheme theme = HelperFunctions.isDarkMode ? DarkTheme() : LightTheme();
  final JobsActions jobsActions = JobsActions();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController districtController;
  late final TextEditingController geoPointController;
  late final TextEditingController salaryController;
  late DateTime selectedDate = DateTime.now();
  late String startTime;
  late String endTime;
  String selectedMajor = "None";
  String selectedPer = "Per";
  String jobImageUrl = "None";
  int selectedWorkersNeeded = 0;
  List<int> oneToTen =
      List<int>.generate(10, (i) => i + 1); // list for how much workers needed

  @override
  void initState() {
    startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
    endTime = DateFormat('hh:mm a')
        .format(DateTime.now().add(const Duration(minutes: 15)))
        .toString();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    districtController = TextEditingController();
    geoPointController = TextEditingController();
    salaryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    districtController.dispose();
    geoPointController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  Widget getJobImageFromUser() {
    return Container(
        height: 100,
        child: Card(
          semanticContainer: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: theme.elevation,
          margin: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () async {
              jobImageUrl = await jobsActions.chooseUploadJobImage(
                  titleController.text + AuthActions.currUser.uid);
              setState(() {
                if (jobImageUrl == "ERROR") {
                  jobImageUrl = "None";
                }
              });
            },
            child: Image.network(
              jobImageUrl == "None"
                  ? "https://static.thenounproject.com/png/1156518-200.png"
                  : jobImageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: theme.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              InputField(
                title: 'Title',
                hint: 'Enter job title here...',
                fieldController: titleController,
              ),

              InputField(
                title: 'Description',
                hint: 'Enter job Description here...',
                fieldController: descriptionController,
                highet: 100,
              ),
              FutureBuilder(
                future: jobsActions.getJobsMajors(),
                builder: (context, majorsSnap) => InputField(
                  title: 'Job major',
                  hint: selectedMajor,
                  child: DropdownButton(
                    dropdownColor: theme.cardColor,
                    onChanged: (String? newMajor) {
                      setState(() {
                        selectedMajor = newMajor!;
                      });
                    },
                    items: majorsSnap.data != null
                        ? majorsSnap.data!
                            .map<DropdownMenuItem<String>>(
                              (major) => DropdownMenuItem<String>(
                                value: major,
                                child: Text(major, style: TextStyle(color: theme.textFieldTextColor),),
                              ),
                            )
                            .toList()
                        : [const DropdownMenuItem<String>(child: Text(" "))],
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
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(selectedDate),
                child: IconButton(
                  onPressed: () => getDateFromUser(),
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: theme.secondaryIconColor,
                  ),
                ),
              ),
              //Date Range
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: startTime,
                      child: IconButton(
                        onPressed: () => getTimeFromUser(isStartTime: true),
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: theme.secondaryIconColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: endTime,
                      child: IconButton(
                        onPressed: () => getTimeFromUser(isStartTime: false),
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: theme.secondaryIconColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Workers needed',
                hint: '${selectedWorkersNeeded.toString()} needed',
                child: DropdownButton<int>(
                  dropdownColor: theme.cardColor,
                  onChanged: (int? value) {
                    setState(() {
                      selectedWorkersNeeded = value!;
                    });
                  },
                  items: oneToTen
                      .map<DropdownMenuItem<int>>(
                        (number) => DropdownMenuItem<int>(
                          value: number,
                          child: Text('${number.toString()} needed', style: TextStyle(color: theme.textFieldTextColor),),
                        ),
                      )
                      .toList(),
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
              SearchPlace(
                  districtController: districtController,
                  geoPointController: geoPointController),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      keyboardType: TextInputType.number,
                      title: 'Salary',
                      hint: 'Enter a salary',
                      fieldController: salaryController,
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      title: 'Per',
                      hint: selectedPer,
                      child: DropdownButton(
                        dropdownColor: theme.cardColor,
                        onChanged: (String? newMajor) {
                          setState(() {
                            selectedPer = newMajor!;
                          });
                        },
                        items: ['Hour', 'Job']
                            .map<DropdownMenuItem<String>>(
                              (major) => DropdownMenuItem<String>(
                                value: major,
                                child: Text(major, style: TextStyle(color: theme.textFieldTextColor),),
                              ),
                            )
                            .toList(),
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
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              getJobImageFromUser(),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: PostButton(
          label: 'Post Job',
          onTap: () async {
            if (!validateFileds()) {
              // we print a dialog here in the function if not valid
              return;
            }
            try {
              await jobsActions.postJob(Job(
                  availableSpots: selectedWorkersNeeded,
                  date: Timestamp.fromDate(selectedDate),
                  description: descriptionController.text,
                  employerUid: AuthActions.currUser.uid,
                  location: GeoPoint(
                      double.parse(geoPointController.text.split(",")[0]),
                      double.parse(geoPointController.text.split(",")[1])),
                  salary: int.parse(salaryController.text),
                  per: selectedPer,
                  signedWorkers: [],
                  title: titleController.text,
                  major: selectedMajor,
                  imageUrl: jobImageUrl,
                  district: districtController.text,
                  approvedWorkers: [],
                  amountNeeded: selectedWorkersNeeded));
              showModalBottomSheet(
                  // TODO: replace with this snack shit
                  barrierColor: Colors.black.withOpacity(0.3),
                  context: context,
                  builder: ((context) => StatefulBuilder(
                      builder: ((context, setState) => Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(children: const [
                            Icon(Icons.verified),
                            SizedBox(width: 20),
                            Text("Job Posted successfully!"),
                          ]))))));
            } catch (e) {
              showModalBottomSheet(
                  // TODO: replace with this snack shit
                  barrierColor: Colors.black.withOpacity(0.3),
                  context: context,
                  builder: ((context) => StatefulBuilder(
                      builder: ((context, setState) => Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(children: const [
                            Icon(
                              Icons.warning,
                              color: Colors.red,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "Unknown error in posting jobs",
                              style: TextStyle(color: Colors.red),
                            ),
                          ]))))));
            }
          }),
    );
  }

  AppBar appBar() {
    return AppBar(
      toolbarHeight: 36,
      title: Center(
          child: Text(
        'Job Posting',
        style: TextStyle(
            fontSize: 26,
            fontWeight:
            FontWeight.bold,
            color: theme.titleColor),
      )),
      shadowColor: Colors.black.withOpacity(0.4),
      bottomOpacity: 0.9,
      backgroundColor: theme.appBarColor,
    );
  }

  bool validateFileds() {
    if (geoPointController.text.isEmpty ||
        districtController.text.isEmpty ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedMajor == "None" ||
        selectedWorkersNeeded == 0 ||
        selectedPer == "Per") {
      showModalBottomSheet(
          // TODO: replace with this snack shit
          barrierColor: Colors.black.withOpacity(0.3),
          context: context,
          builder: ((context) => StatefulBuilder(
              builder: ((context, setState) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(children: const [
                    Icon(
                      Icons.warning,
                    ),
                    SizedBox(width: 20),
                    Text("All fileds are require"),
                  ]))))));
      return false;
    }
    return true;
  }

  getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime.format(context);
        } else {
          endTime = pickedTime.format(context);
        }
      });
    }
  }
}

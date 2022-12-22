import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:time_z_money/business_Logic/models/Job.dart';
import '../../business_Logic/actions/auth_actions.dart';
import '../../business_Logic/actions/jobs_actions.dart';
import 'Component/button.dart';
import 'Component/inputfiled.dart';
import 'Component/places_search.dart';

class UploadJobScreen extends StatefulWidget {
  const UploadJobScreen({Key? key}) : super(key: key);

  @override
  State<UploadJobScreen> createState() => _UploadJobScreenState();
}

class _UploadJobScreenState extends State<UploadJobScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController districtController;
  late final TextEditingController geoPointController;
  late final JobsActions jobsActions = JobsActions();
  late DateTime selectedDate = DateTime.now();
  late String startTime;
  late String endTime;
  String selectedMajor = "None";
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
    super.initState();
  }

  @override
  void dispose() {
    districtController.dispose();
    geoPointController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              InputField(
                title: 'Title',
                hint: 'Enter gig title here...',
                fieldController: titleController,
              ),

              InputField(
                title: 'Description',
                hint: 'Enter gig Description here...',
                fieldController: descriptionController,
                highet: 100,
              ),
              FutureBuilder(
                future: jobsActions.getJobsMajors(),
                builder: (context, majorsSnap) => InputField(
                  title: 'Gig major',
                  hint: selectedMajor,
                  child: DropdownButton(
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
                                child: Text(major),
                              ),
                            )
                            .toList()
                        : [const DropdownMenuItem<String>(child: Text(" "))],
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 32,
                      color: Colors.grey,
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
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
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
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
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
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
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
                  onChanged: (int? value) {
                    setState(() {
                      selectedWorkersNeeded = value!;
                    });
                  },
                  items: oneToTen
                      .map<DropdownMenuItem<int>>(
                        (number) => DropdownMenuItem<int>(
                          value: number,
                          child: Text('${number.toString()} needed'),
                        ),
                      )
                      .toList(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 32,
                    color: Colors.grey,
                  ),
                  elevation: 3,
                  underline: Container(height: 0),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SearchPlace(
                  districtController: districtController,
                  geoPointController: geoPointController),
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
              await jobsActions.postJob(Job( // TODO: add salary filed and image upload filed (image wil be optional)
                  availableSpots: selectedWorkersNeeded,
                  date: Timestamp.fromDate(selectedDate),
                  description: descriptionController.text,
                  employerUid: AuthActions.currUser.uid,
                  location: GeoPoint(
                      double.parse(geoPointController.text.split(",")[0]),
                      double.parse(geoPointController.text.split(",")[1])),
                  salary: 5,
                  signedWorkers: [],
                  title: titleController.text,
                  major: selectedMajor,
                  imageUrl:
                      "https://img.freepik.com/free-vector/excited-mom-son-having-fun-woman-boy-jumping-dancing-flat-illustration_74855-10616.jpg",
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
      toolbarHeight: 35,
      title: const Center(
          child: Text(
        'Gig Posting',
        style: TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
      )),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  bool validateFileds() {
    if (geoPointController.text.isEmpty ||
        districtController.text.isEmpty ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedMajor == "None" ||
        selectedWorkersNeeded == 0) {
      showModalBottomSheet(
          // TODO: replace with this snack shit
          barrierColor: Colors.black.withOpacity(0.3),
          context: context,
          builder: ((context) => StatefulBuilder(
              builder: ((context, setState) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(children: const [
                    Icon(Icons.warning,),
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
    } else
      print('picked date empty !');
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
          print(startTime);
        } else {
          endTime = pickedTime.format(context);
          print(endTime);
        }
      });
    }
  }
}

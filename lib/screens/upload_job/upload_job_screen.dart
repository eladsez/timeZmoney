import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../business_Logic/actions/jobs_actions.dart';
import 'Component/button.dart';
import 'Component/inputfiled.dart';

class UploadJobScreen extends StatefulWidget {
  const UploadJobScreen({Key? key}) : super(key: key);

  @override
  State<UploadJobScreen> createState() => _UploadJobScreenState();
}

class _UploadJobScreenState extends State<UploadJobScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final JobsActions jobsActions = JobsActions();
  late DateTime selectedDate = DateTime.now();
  late String startTime;
  late String endTime;
  String selectedMajor = "None";
  int selectedWorkersNeeded = 0;
  List<int> oneToTen =
      List<int>.generate(10, (i) => i + 1); // list for how much workers needed

  int selectedColor = 0;
  List<Color> colorList = [Colors.brown, Colors.greenAccent, Colors.green];

  @override
  void initState() {
    startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
    endTime = DateFormat('hh:mm a')
        .format(DateTime.now().add(const Duration(minutes: 15)))
        .toString();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
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
              //Color
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Color',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: List.generate(
                        colorList.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 5.0, top: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedColor = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: CircleAvatar(
                              backgroundColor: colorList[index],
                              child: index == selectedColor
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MyButton(
          label: 'Post Job',
          onTap: () {
            validateDate();
          }),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Center(
          child: Text(
        'Gig Posting',
        style: TextStyle(
            fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
      )),
      elevation: 2,
      backgroundColor: Colors.white,
    );
  }

  validateDate() {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      // addTaskToDb(); TODO:
    } else if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fileds are required',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.red,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    } else {
      print('######## Error Here ! ########'); // TODO:
    }
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

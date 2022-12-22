import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'Component/button.dart';
import 'Component/inputfiled.dart';

class UploadJobScreen extends StatefulWidget {
  const UploadJobScreen({Key? key}) : super(key: key);

  @override
  State<UploadJobScreen> createState() => _UploadJobScreenState();
}

class _UploadJobScreenState extends State<UploadJobScreen> {
  late final TextEditingController titleController;
  late final TextEditingController noteController;

  late DateTime selecteDate = DateTime.now();
  late String startTime =
      DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int selectedColor = 0;
  List<Color> colorList = [Colors.brown, Colors.greenAccent, Colors.green];

  @override
  void initState() {
    titleController = TextEditingController();
    noteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Title
              InputField(
                title: 'Title',
                hint: 'Enter your title here...',
                fieldController: titleController,
              ),
              //Note
              InputField(
                title: 'Note',
                hint: 'Enter your note here...',
                fieldController: noteController,
              ),
              //Date
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(selecteDate),
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
              //Remind
              InputField(
                title: 'Date',
                hint: '$selectedRemind minutes early',
                child: DropdownButton(
                  onChanged: (String? newVal) {
                    setState(() {
                      selectedRemind = int.parse(newVal!);
                    });
                  },
                  items: remindList
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem<String>(
                          value: e.toString(),
                          child: Text('$e minutes'),
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
              //Repeat
              InputField(
                title: 'Date',
                hint: selectedRepeat,
                child: DropdownButton<String>(
                  onChanged: (String? value) {
                    setState(() {
                      selectedRepeat = value!;
                    });
                  },
                  items: repeatList
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
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

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'Add Task',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: Colors.grey,
        ),
      ),
    );
  }

  validateDate() {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      // addTaskToDb(); TODO:
      Get.back();
    } else if (titleController.text.isEmpty || noteController.text.isEmpty) {
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
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: selecteDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null) {
      setState(() {
        selecteDate = _pickedDate;
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

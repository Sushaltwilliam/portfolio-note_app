import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_app/const/colors.dart';
import 'package:note_app/const/theme.dart';
import 'package:note_app/controllers/task_controller.dart';
import 'package:note_app/models/task.dart';
import 'package:note_app/widget/button.dart';
import 'package:note_app/widget/inputfield.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String endTime = '9.30 AM';
  int _selectedRemaind = 5;
  List<int> remaindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
  ];
  int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              MyInputField(
                title: 'Title',
                hint: 'Enter your title',
                controller: _titleTextEditingController,
              ),
              MyInputField(
                title: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
              ),
              MyInputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(selectedDate),
                  widget: IconButton(
                      onPressed: () {
                        _getDateFromUser();
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ))),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: 'Start Time',
                    hint: startTime,
                    widget: IconButton(
                        onPressed: () {
                          _getUserTimePicker(isStartTime: true);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        )),
                  )),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: MyInputField(
                    title: 'End Time',
                    hint: endTime,
                    widget: IconButton(
                        onPressed: () {
                          _getUserTimePicker(isStartTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        )),
                  )),
                ],
              ),
              MyInputField(
                title: 'Remaind',
                hint: "$_selectedRemaind minutes early",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 25,
                  underline: Container(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRemaind = int.parse(value.toString());
                    });
                  },
                  elevation: 4,
                  style: titleStyle,
                  items: remaindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: 'Repeat',
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 25,
                  underline: Container(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRepeat = value.toString();
                    });
                  },
                  elevation: 4,
                  style: titleStyle,
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(
                        value.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Color',
                        style: titleStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Wrap(
                        children: List<Widget>.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = index;
                                });
                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: index == 0
                                    ? primaryClr
                                    : index == 1
                                        ? pinkClr
                                        : Colors.orange,
                                child: selectedColor == index
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : Container(),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  MyButton(
                      lable: 'Create Task',
                      onTap: () {
                        _validateData();
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleTextEditingController.text.isNotEmpty &&
        _noteController.text.isNotEmpty) {
      addTaskToDb();
      Get.back();
    } else if (_titleTextEditingController.text.isEmpty ||
        _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          icon: Icon(Icons.warning_amber_rounded));
    }
  }

  addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
      note: _noteController.text,
      color: selectedColor,
      date: DateFormat.yMd().format(selectedDate),
      endDate: endTime,
      isCompleted: 0,
      remind: _selectedRemaind,
      repeat: _selectedRepeat,
      startDate: startTime,
      title: _titleTextEditingController.text,
    ));
    print('My value is ${value.toString()}');
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage('Assets/Images/profile.png'),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(3000));
    if (_pickDate != null) {
      selectedDate = _pickDate;
      setState(() {});
    } else {}
  }

  _getUserTimePicker({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('Time Cancel');
    } else if (isStartTime == true) {
      setState(() {
        startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() async {
    return await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(startTime.split(":")[0]),
          minute: int.parse(startTime.split(":")[1].split(" ")[0])),
    );
  }
}

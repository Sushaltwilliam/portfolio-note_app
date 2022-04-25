import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note_app/const/colors.dart';
import 'package:note_app/const/theme.dart';
import 'package:note_app/controllers/task_controller.dart';
import 'package:note_app/screen/add_taskbar.dart';
import 'package:note_app/services/notification.dart';
import 'package:note_app/services/theme_services.dart';
import 'package:note_app/widget/button.dart';

import '../models/task.dart';
import '../widget/tasktile.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  DateTime selectedDateTime = DateTime.now();
  final _taskController = Get.put(TaskController());

  var notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTask();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 30,
          ),
          _showTask()
        ],
      ),
    );
  }

  _showTask() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (ctx, index) {
            Task task = _taskController.taskList[index];
            if (task.repeat == 'Daily') {
              DateTime date = DateFormat.jm().parse(task.startDate.toString());
              var myTime = DateFormat("HH:mm").format(date);
              print(myTime.toString() + '-->>my time');
              notifyHelper.scheduledNotification(
                  hour: int.parse(myTime.toString().split(':')[0]),
                  min: int.parse(myTime.toString().split(':')[1]),
                  tasK: task);

              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  )));
            }
            if (task.date == DateFormat.yMd().format(selectedDateTime)) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  )));
            } else {
              return Container();
            }
          });
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  lable: 'Task Completed',
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  color: primaryClr,
                  context: context),
          SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
              lable: 'Delete Task',
              onTap: () {
                _taskController.delete(task);

                Get.back();
              },
              color: Colors.red[300]!,
              context: context),
          SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
              lable: 'Close',
              onTap: () {
                Get.back();
              },
              isClose: true,
              color: Colors.white,
              context: context),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }

  _bottomSheetButton({
    required String lable,
    required Function()? onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: isClose == true ? Colors.white : color,
            border: Border.all(
                width: 2,
                color: isClose == true
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : color),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(lable,
                style: isClose
                    ? titleStyle.copyWith(color: Colors.black)
                    : titleStyle.copyWith(color: Colors.white))),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        onDateChange: (date) {
          setState(() {
            selectedDateTime = date;
          });
          print(selectedDateTime);
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMEd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              lable: '+ Add Task',
              onTap: () async {
                await Get.to(const AddTaskScreen());
                _taskController.getTask();
              })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().swithchTheme();

          notifyHelper.displayNotification(
              title: 'Theme Changed',
              body: !Get.isDarkMode
                  ? "Activited Dark Theme"
                  : "Activated Light Theme");
          // notifyHelper.scheduledNotification();
          setState(() {});
        },
        child: Icon(
          !Get.isDarkMode ? Icons.nightlight_round : Icons.sunny,
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
}

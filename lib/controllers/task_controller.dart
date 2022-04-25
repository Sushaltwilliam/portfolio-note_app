import 'package:get/get.dart';
import 'package:note_app/database/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) async {
    return await DBHelper.insert(task);
  }

  void getTask() async {
    List<Map<String, dynamic>> task = await DBHelper.query();
    taskList.assignAll(task.map((data) => Task.fromMap(data)).toList());
  }

  void delete(Task task) async {
    DBHelper.delete(task);
    getTask();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTask();
  }
}

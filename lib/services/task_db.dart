import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_pod_hive/model/task_book.dart';
import 'package:todo_pod_hive/model/task.dart';
import 'package:todo_pod_hive/services/i_task_db.dart';

class TaskDBServices implements ITaskDBServices {
  final String TaskBoxKey = "TaskBox";
  final String TaskBookKey = "TaskBook";
  @override
  Future<bool> deleteATask({required int currentTaskId}) async {
    final taskBook = await getAllTasks();
    taskBook.allTasks.removeWhere((element) => element.id == currentTaskId);
    final taskBookBox = await Hive.openBox(TaskBoxKey);
    taskBookBox.put(TaskBookKey, taskBook.toJson());
    return true;
  }

  @override
  Future<TaskBook> getAllTasks() async {
    final taskBox = await Hive.openBox(TaskBoxKey);
    final taskBookJson = taskBox.get(TaskBookKey);
    if (taskBookJson != null) {
      return TaskBook.fromJson(taskBookJson);
    } else {
      return TaskBook(allTasks: []);
    }
  }

  @override
  Future<int> getLastTaskId() async {
    final taskBook = await getAllTasks();
    if (taskBook.allTasks.isNotEmpty) {
      return taskBook.allTasks.last.id + 1;
    } else {
      return 0;
    }
  }

  @override
  Future<bool> saveATask({required Task task}) async {
    final taskBook = await getAllTasks();
    final oldTasks = taskBook.allTasks;
    oldTasks.add(task);
    final newTasks = oldTasks;
    final newTaskBook = TaskBook(allTasks: newTasks);
    final taskBookBox = await Hive.openBox(TaskBoxKey);
    taskBookBox.put(TaskBookKey, newTaskBook.toJson());
    return true;
  }

  @override
  Future<bool> updateATask(
      {required int currentTaskId, required Task task}) async {
    final taskBook = await getAllTasks();
    final index =
        taskBook.allTasks.indexWhere((element) => element.id == currentTaskId);
    taskBook.allTasks[index] = task;
    final taskBookBox = await Hive.openBox(TaskBoxKey);
    taskBookBox.put(TaskBookKey, taskBook.toJson());
    return true;
  }
}

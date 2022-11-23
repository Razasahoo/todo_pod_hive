import 'package:todo_pod_hive/model/task.dart';
import 'package:todo_pod_hive/model/task_book.dart';

abstract class ITaskDBServices {
  Future<bool> saveATask({required Task task});
  Future<bool> deleteATask({required int currentTaskId});
  Future<bool> updateATask({required int currentTaskId, required Task task});
  Future<int> getLastTaskId();
  Future<TaskBook> getAllTasks();
}

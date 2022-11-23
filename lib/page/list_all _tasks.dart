import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_pod_hive/model/task.dart';
import 'package:todo_pod_hive/model/task_book.dart';
import 'package:todo_pod_hive/page/add_a_task_page.dart';
import 'package:todo_pod_hive/page/update_a_task_page.dart';
import 'package:todo_pod_hive/services/task_db.dart';

class ListAllTaskPage extends StatefulWidget {
  const ListAllTaskPage({super.key});

  @override
  State<ListAllTaskPage> createState() => _ListAllTaskPageState();
}

class _ListAllTaskPageState extends State<ListAllTaskPage> {
  final TaskDBServices tasks = TaskDBServices();

  List<Task> allTasks = <Task>[];

  Future<TaskBook> getTaskBook() async {
    final taskBook = await tasks.getAllTasks();
    return taskBook;
  }

  Future<void> getAllTask() async {
    final taskBook = await getTaskBook();
    allTasks = taskBook.allTasks;
    setState(() {});
  }

  Future<void> deleteTask(int currentTaskId) async {
    final result = await tasks.deleteATask(currentTaskId: currentTaskId);
    if (result) {
      getAllTask();
    }
  }

  @override
  void initState() {
    getAllTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: allTasks.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.teal.shade300,
                  Colors.white,
                ], begin: Alignment.bottomCenter, end: Alignment.center),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemCount: allTasks.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final task = allTasks[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.teal,
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    "${task.id}",
                                  ),
                                ),
                                title: Text(
                                  " ${task.title}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, 
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    deleteTask(task.id);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.teal,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => UpdateATaskPage(
                                            task: task,
                                            onUpdated: (() {
                                              getAllTask();
                                            }),
                                          ))));
                                },
                              ),
                              const Divider(
                                thickness: 3,
                                endIndent: 12,
                                indent: 12,
                                color: Colors.teal,
                              ),
                              ListTile(
                                subtitle: Text(task.subTitle),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => UpdateATaskPage(
                                            task: task,
                                            onUpdated: (() {
                                              getAllTask();
                                            }),
                                          ))));
                                },
                              ),
                              ListTile(
                                trailing: Text(
                                  task.datetime.toString(),
                                  style: const TextStyle(
                                    color: Colors.teal,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : const Center(
              child: Text("No Tasks"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => AddATaskPage(
                    onAdded: () {
                      getAllTask();
                    },
                  ))));
        },
        child: const Icon(Icons.add_box),
      ),
    );
  }
}

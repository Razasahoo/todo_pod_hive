import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_pod_hive/model/task.dart';
import 'package:todo_pod_hive/services/task_db.dart';

class AddATaskPage extends StatefulWidget {
  final void Function() onAdded;
  const AddATaskPage({super.key, required this.onAdded});

  @override
  State<AddATaskPage> createState() => _AddATaskPageState();
}

class _AddATaskPageState extends State<AddATaskPage> {
  final TaskDBServices taskDBServices = TaskDBServices();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTileController = TextEditingController();

  Future<int> getLastestId() async {
    final result = await taskDBServices.getLastTaskId();
    return result;
  }

  Future<void> createATask(BuildContext context, Task task) async {
    try {
      final result = await taskDBServices.saveATask(task: task);
      if (result) {
        if (mounted) {
          widget.onAdded();
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  void clearText() {
    _titleController.clear();
    _subTileController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    } else if (value.length >= 20) {
                      return 'Your should be less than 20';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _subTileController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final task = Task(
                        id: await getLastestId(),
                        title: _titleController.text,
                        subTitle: _subTileController.text,
                        datetime: DateTime.now(),
                      );
                      if (mounted) {
                        createATask(context, task);
                      }
                    }
                  },
                  child: const Text("Add Contact"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

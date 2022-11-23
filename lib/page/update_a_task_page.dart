import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_pod_hive/model/task.dart';
import 'package:todo_pod_hive/services/task_db.dart';

class UpdateATaskPage extends StatefulWidget {
  final Task task;
  final void Function() onUpdated;
  const UpdateATaskPage(
      {super.key, required this.task, required this.onUpdated});

  @override
  State<UpdateATaskPage> createState() => _UpdateATaskPageState();
}

class _UpdateATaskPageState extends State<UpdateATaskPage> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTileController = TextEditingController();

  final TaskDBServices taskDBServices = TaskDBServices();

  Future<void> updateTask() async {
    try {
      if (_titleController.text == widget.task.title &&
          _subTileController.text == widget.task.subTitle) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please Edit Something to Update"),
          ),
        );
      } else {
        final result = await taskDBServices.updateATask(
          currentTaskId: widget.task.id,
          task: widget.task.copyWith(
            title: _titleController.text,
            subTitle: _subTileController.text,
          ),
        );
        if (result) {
          widget.onUpdated();
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  void initState() {
    _titleController.text = widget.task.title;
    _subTileController.text = widget.task.subTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Task"),
      ),
      body: Form(
        key: _formkey,
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
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      updateTask();
                    }
                  },
                  child: const Text("update contact"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

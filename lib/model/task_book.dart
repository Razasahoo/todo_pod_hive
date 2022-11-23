import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:todo_pod_hive/model/task.dart';

class TaskBook {
  final List<Task> allTasks;
  TaskBook({
    required this.allTasks,
  });

  TaskBook copyWith({
    List<Task>? allTasks,
  }) {
    return TaskBook(
      allTasks: allTasks ?? this.allTasks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allTasks': allTasks.map((x) => x.toMap()).toList(),
    };
  }

  factory TaskBook.fromMap(Map<String, dynamic> map) {
    return TaskBook(
      allTasks: List<Task>.from(map['allTasks']?.map((x) => Task.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskBook.fromJson(String source) => TaskBook.fromMap(json.decode(source));

  @override
  String toString() => 'TaskBook(allTasks: $allTasks)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TaskBook &&
      listEquals(other.allTasks, allTasks);
  }

  @override
  int get hashCode => allTasks.hashCode;
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_pod_hive/page/list_all%20_tasks.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Task',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const ListAllTaskPage(),
    );
  }
}

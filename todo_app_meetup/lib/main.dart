import 'package:flutter/material.dart';
import 'screens/task_list_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo Demo',
      theme: ThemeData.dark(),
      home: TaskListView(),
    );
  }
}

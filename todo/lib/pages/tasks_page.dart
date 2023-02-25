import 'package:flutter/material.dart';

/// The tasks page which will display all the tasks for a certain user.
class TasksPage extends StatefulWidget {
  // route name of the page
  static const String routeName = '/';

  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

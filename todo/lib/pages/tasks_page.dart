import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// The tasks page which will display all the tasks for a certain user.
class TasksPage extends StatefulWidget {
  // route name of the page
  static const String routeName = '/tasks';

  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () async {
              // sign out the user
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}

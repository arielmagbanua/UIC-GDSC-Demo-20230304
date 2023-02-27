import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  // route name of the page
  static const String routeName = '/add-task';

  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  // text input controllers for managing and controlling text inputs
  final _titleInputController = TextEditingController();
  final _deadlineInputController = TextEditingController();
  final _deadlineTimeInputController = TextEditingController();

  // tasks reference
  final _tasksRef = FirebaseFirestore.instance.collection('tasks');

  // current authenticated user
  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                // one of the form field is invalid
                return;
              }

              // create the task object
              final task = <String, dynamic>{
                'title': _titleInputController.text,
                'finished': false,
                'owner': _currentUser!.email,
              };

              // create the deadline timestamp
              final dateStr =
                  '${_deadlineInputController.text} ${_deadlineTimeInputController.text}:00';
              final deadline = DateTime.parse(dateStr);
              task['deadline'] = deadline;

              // save the task
              await _tasksRef.doc().set(task);

              // notify the task is added
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${_titleInputController.text} added')),
              );

              // close the add task page
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32.0,
          horizontal: 16.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  helperText: 'The title of the task.',
                  border: OutlineInputBorder(),
                ),
                controller: _titleInputController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // no title provided
                    return 'Please provide the title';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  helperText: 'The deadline of the task.',
                  border: OutlineInputBorder(),
                ),
                controller: _deadlineInputController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // no date provided
                    return 'Please provide a date for deadline';
                  }

                  return null;
                },
                readOnly: true,
                onTap: () async {
                  final today = DateTime.now();
                  final daysFromToday = today.add(const Duration(days: 60));

                  // grab the selected date via date picker
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: today,
                    firstDate: today,
                    lastDate: daysFromToday,
                  );

                  setState(() {
                    // set the date of the deadline
                    if (selectedDate != null) {
                      final year = selectedDate.year;
                      final month = selectedDate.month.toString().padLeft(2, '0');
                      final day = selectedDate.day.toString().padLeft(2, '0');

                      _deadlineInputController.text = '$year-$month-$day';
                    } else {
                      _deadlineInputController.text = '';
                    }
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  helperText: 'The deadline time.',
                  border: OutlineInputBorder(),
                ),
                controller: _deadlineTimeInputController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // no time provided
                    return 'Please provide a time for deadline';
                  }

                  return null;
                },
                readOnly: true,
                onTap: () async {
                  // grab the selected time via time picker
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 8, minute: 0),
                  );

                  setState(() {
                    // set the time of the deadline
                    if (selectedTime != null) {
                      final hour = selectedTime.hour.toString().padLeft(2, '0');
                      final minutes =
                          selectedTime.minute.toString().padLeft(2, '0');
                      _deadlineTimeInputController.text = '$hour:$minutes';
                    } else {
                      _deadlineTimeInputController.text = '';
                    }
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

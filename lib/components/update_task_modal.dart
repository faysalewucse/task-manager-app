import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:task_manager/auth/auth.dart';
import 'package:task_manager/components/task_form_field.dart';
import '../model/task_model.dart';

class UpdateTaskDialog extends StatefulWidget {
  final Task task;

  const UpdateTaskDialog({
    super.key,
    required this.task
  });

  @override
  UpdateTaskDialogState createState() => UpdateTaskDialogState();
}

class UpdateTaskDialogState extends State<UpdateTaskDialog> {
  late Task _task;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  User? user = Auth().currentUser;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    selectedDate = widget.task.dueDate;
    selectedTime = widget.task.dueTime;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController title = TextEditingController(text: _task.title);
    TextEditingController description = TextEditingController(text: _task.description);

    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
        'Update Task',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TaskFormField(controller: title, hintText: 'Title'),
            TaskFormField(controller: description, hintText: 'Description'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Set Due Date'),
              subtitle: Text(
                '${_task.dueDate.day}/${_task.dueDate.month}/${_task.dueDate.year}',
              ),
              onTap: () async {
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: _task.dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (newDate != null) {
                  setState(() {
                    selectedDate = newDate;
                  });
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Set Due Time'),
              subtitle: Text(_task.dueTime.format(context)),
              onTap: () async {
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: _task.dueTime,
                );
                if (newTime != null) {
                  setState(() {
                    selectedTime = newTime;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        SizedBox(
          width: 80,
          child: RoundedLoadingButton(
            controller: _btnController,
            color: Colors.redAccent,
            onPressed: () {
              DatabaseReference databaseReference =
                  FirebaseDatabase.instance.ref();
              final user = this.user;
              if (user != null) {
                DatabaseReference userReference =
                    databaseReference.child(user.uid);

                userReference.child(_task.id).remove().then((value) {
                  // Data insertion successful
                  Navigator.of(context).pop();
                }).catchError((error) {
                  // Handle error
                  _btnController.stop();
                });
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ),
        SizedBox(
          width: 90,
          child: RoundedLoadingButton(
            controller: _btnController,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              DatabaseReference databaseReference =
                  FirebaseDatabase.instance.ref();
              final user = this.user;
              if (user != null) {
                DatabaseReference userReference =
                    databaseReference.child(user.uid);

                Map<String, String> task = {
                  'title': title.text,
                  'description': description.text,
                  'updatedAt': DateTime.now().toString(),
                  'dueDate': selectedDate.toString(),
                  'dueTime': selectedTime.format(context),
                };

                userReference.child(_task.id).update(task).then((value) {
                  // Data insertion successful
                  Navigator.of(context).pop();
                }).catchError((error) {
                  // Handle error
                  _btnController.stop();
                });
              }
            },
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }
}

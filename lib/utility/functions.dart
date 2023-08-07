import 'package:flutter/material.dart';
import 'package:task_manager/components/update_task_modal.dart';
import 'package:task_manager/model/task_model.dart';

void showUpdateTaskDialog(BuildContext context, Task task) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UpdateTaskDialog(task: task);
    },
  );
}

TimeOfDay convertTime(value) {
  return TimeOfDay(
    hour: int.parse(value['dueTime'].split(':')[0]),
    minute: int.parse(value['dueTime'].split(':')[1].split(' ')[0]),
  );
}
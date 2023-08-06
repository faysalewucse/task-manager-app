import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TimeOfDay dueTime;
  final bool status;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.dueTime,
    required this.status,
    required this.id,
  });

}

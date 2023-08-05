import 'package:flutter/material.dart';

class TaskFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const TaskFormField({Key? key, required this.controller, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText),
      controller: controller,
      maxLines: null,
      validator: (String? value) {
        return (value == null) ? '$hintText is blank' : null;
      },
    );
  }
}

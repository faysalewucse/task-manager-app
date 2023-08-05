import 'package:flutter/material.dart';
import 'package:task_manager/components/task_form_field.dart';

class AddTaskDialog extends StatefulWidget {
  final bool customDueTime;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<bool> onCustomDueTimeChanged;

  const AddTaskDialog({
    super.key,
    required this.customDueTime,
    required this.selectedDate,
    required this.selectedTime,
    required this.onCustomDueTimeChanged,
  });

  @override
  AddTaskDialogState createState() => AddTaskDialogState();
}

class AddTaskDialogState extends State<AddTaskDialog> {
  bool _customDueTime = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customDueTime = widget.customDueTime;
    selectedDate = widget.selectedDate;
    selectedTime = widget.selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
        'Add Task',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
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
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
              onTap: () async {
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
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
              leading: Checkbox(
                value: _customDueTime,
                onChanged: (newValue) {
                  setState(() {
                    _customDueTime = newValue!;
                    widget.onCustomDueTimeChanged(newValue);
                  });
                },
              ),
              title: const Text('Set Due Time'),
              subtitle: Text(selectedTime.format(context)),
              onTap: () async {
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
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
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),

          ),
          onPressed: () {
            print("${title.text}**${description.text}");
          },
          child: const Text('Add', style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}

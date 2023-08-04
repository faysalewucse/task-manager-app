import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final bool customDueDate;
  final bool customDueTime;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<bool> onCustomDueDateChanged;
  final ValueChanged<bool> onCustomDueTimeChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const AddTaskDialog({
    required this.customDueDate,
    required this.customDueTime,
    required this.selectedDate,
    required this.selectedTime,
    required this.onCustomDueDateChanged,
    required this.onCustomDueTimeChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {

  bool _customDueDate = false;
  bool _customDueTime = false;

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customDueDate = widget.customDueDate;
    _customDueTime = widget.customDueTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
        'Add Task',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: title,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'),
            controller: description,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Checkbox(
              value: _customDueDate,
              onChanged: (newValue) {
                setState(() {
                  _customDueDate = newValue!;
                  widget.onCustomDueDateChanged(newValue);
                });
              },
            ),
            title: Text('Set Due Date'),
            subtitle: Text(
              '${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day} ${widget.selectedTime.format(context)}',
            ),
            onTap: () async {
              final newDate = await showDatePicker(
                context: context,
                initialDate: widget.selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (newDate != null) {
                widget.onDateChanged(newDate);
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
            subtitle: Text(widget.selectedTime.format(context)),
            onTap: () async {
              final newTime = await showTimePicker(
                context: context,
                initialTime: widget.selectedTime,
              );
              if (newTime != null) {
                widget.onTimeChanged(newTime);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            print(title.text + "**" + description.text);
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

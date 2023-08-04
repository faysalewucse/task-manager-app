import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/components/add_task_modal.dart';
import 'package:task_manager/model/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _customDueDate = false;
  bool _customDueTime = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  List<Task> dummyTasks = [
    Task(
        title: 'Task 1',
        description: 'Complete Flutter app',
        dueDate: DateTime.now().add(Duration(days: 1)),
        status: true),
    Task(
        title: 'Task 2',
        description: 'Write documentation',
        dueDate: DateTime.now().add(Duration(days: 3)),
        status: false),
    Task(
        title: 'Task 3',
        description: 'Refactor code',
        dueDate: DateTime.now().add(Duration(days: 5)),
        status: true),
    Task(
        title: 'Task 1',
        description: 'Complete Flutter app',
        dueDate: DateTime.now().add(Duration(days: 1)),
        status: false),
    Task(
        title: 'Task 2',
        description: 'Write documentation',
        dueDate: DateTime.now().add(Duration(days: 3)),
        status: false),
    Task(
        title: 'Task 3',
        description: 'Refactor code',
        dueDate: DateTime.now().add(Duration(days: 5)),
        status: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Task Manager"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColor,
                  boxShadow: const [
                    BoxShadow(color: Colors.green, spreadRadius: 3),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Today's task",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Almost Completed",
                          style: TextStyle(fontSize: 12),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {},
                            child: const Text(
                              'View Task',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    CircularPercentIndicator(
                      radius: 55.0,
                      lineWidth: 15.0,
                      percent: 0.8,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.black12,
                      center: const Text(
                        "80%",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      progressColor: Colors.white,
                    )
                  ],
                ),
              ),
              const Text(
                'In Progress',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: DottedBorder(
                  color: Theme.of(context).primaryColor,
                  borderType: BorderType.RRect,
                  strokeWidth: 2,
                  dashPattern: const [8, 3],
                  radius: const Radius.circular(12),
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        child: Center(
                          child: Column(
                            children: const [
                              Icon(Icons.hourglass_empty),
                              Text(
                                "No Task In Progress",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      )),
                ),
              ),
              const Text(
                'Today`s Tasks',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dummyTasks.length,
                  itemBuilder: (context, index) {
                    Task task = dummyTasks[index];
                    return Card(
                      color: Colors.green[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                        trailing: MSHCheckbox(
                          size: 25,
                          value: task.status,
                          colorConfig:
                              MSHColorConfig.fromCheckedUncheckedDisabled(
                            checkedColor: Theme.of(context).primaryColor,
                            uncheckedColor: Theme.of(context).primaryColor,
                          ),
                          style: MSHCheckboxStyle.fillScaleColor,
                          onChanged: (selected) {
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            _showAddTaskDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: GNav(
              gap: 5,
              duration: const Duration(milliseconds: 800),
              activeColor: Colors.white,
              color: Theme.of(context).primaryColor,
              tabBackgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(15.0),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.view_agenda,
                  text: 'My Tasks',
                ),
                GButton(
                  icon: Icons.person_2_outlined,
                  text: 'Profile',
                )
              ]),
        ));
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          customDueDate: _customDueDate,
          customDueTime: _customDueTime,
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          onCustomDueDateChanged: (newValue) {
            setState(() {
              _customDueDate = newValue;
            });
          },
          onCustomDueTimeChanged: (newValue) {
            setState(() {
              _customDueTime = newValue;
            });
          },
          onDateChanged: (newDate) {
            setState(() {
              _selectedDate = newDate;
            });
          },
          onTimeChanged: (newTime) {
            setState(() {
              _selectedTime = newTime;
            });
          },
        );
      },
    );
  }
}

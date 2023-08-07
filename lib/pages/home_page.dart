import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/auth/auth.dart';
import 'package:task_manager/components/add_task_modal.dart';
import 'package:task_manager/components/update_task_modal.dart';
import 'package:task_manager/model/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = Auth().currentUser;
  bool _customDueTime = false;
  final DateTime _selectedDate = DateTime.now();
  final TimeOfDay _selectedTime = const TimeOfDay(hour: 23, minute: 59);

  DateFormat formatter = DateFormat('dd/MM/yyyy');

  final List<Color?> randomColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  bool compareDueDate(DateTime dueDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    if (taskDate.isBefore(today)) {
      return true;
    }
    return false;
  }

  num calculateTaskStatus(List tasks) {
    if(tasks.isEmpty) return 0;
    int taskCompleted = 0;
    for (Task i in tasks) {
      if (i.status == true) taskCompleted++;
    }
    int result = (100 * taskCompleted) ~/ tasks.length;

    return result;
  }

  TimeOfDay convertTime(value) {
    return TimeOfDay(
      hour: int.parse(value['dueTime'].split(':')[0]),
      minute: int.parse(value['dueTime'].split(':')[1].split(' ')[0]),
    );
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference userRef = FirebaseDatabase.instance.ref(user!.uid);
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<DatabaseEvent>(
      stream: userRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No data available.');
        }

        List<Task> tasks = [];

        DataSnapshot dataSnapshot = snapshot.data!.snapshot;

        Map<dynamic, dynamic>? dataMap =
            dataSnapshot.value as Map<dynamic, dynamic>?;

        if (dataMap != null) {
          dataMap.forEach((key, value) {
            tasks.add(Task(
              id: key,
              title: value['title'],
              description: value['description'],
              dueDate: DateTime.parse(value['dueDate']),
              dueTime: convertTime(value),
              status: value['status'].toLowerCase() == 'true',
              createdAt: DateTime.parse(value['createdAt']),
              updatedAt: DateTime.parse(value['updatedAt']),
            ));
          });
        }

        return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'View Task',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          CircularPercentIndicator(
                            radius: 55.0,
                            lineWidth: 15.0,
                            percent: calculateTaskStatus(tasks) / 100,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.black12,
                            center: Text(
                              "${calculateTaskStatus(tasks)}%",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                    tasks.isEmpty
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: DottedBorder(
                              color: Theme.of(context).primaryColor,
                              borderType: BorderType.RRect,
                              strokeWidth: 1,
                              dashPattern: const [8, 4],
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(20),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: Container(
                                    padding: const EdgeInsets.all(25),
                                    child: Center(
                                      child: Column(
                                        children: const [
                                          Icon(Icons.hourglass_empty),
                                          Text(
                                            "No Task In Progress",
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        : SizedBox(
                            height: 110,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: tasks.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 200,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      border: Border.all(color: Colors.green),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  margin: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tasks[index].title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Due: ${formatter.format(tasks[index].dueDate)}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: compareDueDate(
                                                        tasks[index].dueDate)
                                                    ? Colors.redAccent
                                                    : Theme.of(context)
                                                        .primaryColor),
                                          ),
                                          Text(
                                            "Time: ${tasks[index].dueTime.format(context)}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                    const Text(
                      'Today`s Tasks',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        height: screenHeight * 0.4,
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            Task task = tasks[index];
                            return GestureDetector(
                              onTap: (){
                                _showUpdateTaskDialog(context, task);
                              },
                              child: Card(
                                color: Colors.green[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  trailing: MSHCheckbox(
                                    size: 25,
                                    value: task.status == true,
                                    colorConfig: MSHColorConfig
                                        .fromCheckedUncheckedDisabled(
                                      checkedColor:
                                          Theme.of(context).primaryColor,
                                      uncheckedColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    style: MSHCheckboxStyle.fillScaleColor,
                                    onChanged: (selected) {
                                      // Update the data in the Firebase database
                                      userRef.child(task.id.toString()).update(
                                          {'status': selected.toString()});
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                _showAddTaskDialog(context);
              },
              child: const Icon(Icons.add),
            ));
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
            selectedDate: _selectedDate,
            selectedTime: _selectedTime,
            onCustomDueTimeChanged: (newValue) {
              setState(() {
                _customDueTime = newValue;
              });
            });
      },
    );
  }

  void _showUpdateTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateTaskDialog(task: task);
      },
    );
  }
}

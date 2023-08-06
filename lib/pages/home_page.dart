import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/auth/auth.dart';
import 'package:task_manager/components/add_task_modal.dart';
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

  @override
  Widget build(BuildContext context) {
    DatabaseReference userRef = FirebaseDatabase.instance.ref(user!.uid);

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
                    strokeWidth: 1,
                    dashPattern: const [8, 4],
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
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
                SizedBox(
                    height: 300,
                    child: FirebaseAnimatedList(
                      shrinkWrap: true,
                      defaultChild: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      query: userRef,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map<dynamic, dynamic> task =
                            snapshot.value as Map<dynamic, dynamic>;

                        return Card(
                          color: Colors.green[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                              task['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            trailing: MSHCheckbox(
                              size: 25,
                              value: task['status'] == 'true',
                              colorConfig:
                                  MSHColorConfig.fromCheckedUncheckedDisabled(
                                checkedColor: Theme.of(context).primaryColor,
                                uncheckedColor: Theme.of(context).primaryColor,
                              ),
                              style: MSHCheckboxStyle.fillScaleColor,
                              onChanged: (selected) {
                                // Update the data in the Firebase database
                                userRef
                                    .child(snapshot.key.toString())
                                    .update({'status': selected.toString()});
                              },
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
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
            customDueTime: _customDueTime,
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
}

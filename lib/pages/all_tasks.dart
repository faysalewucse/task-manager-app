import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:task_manager/auth/auth.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/utility/functions.dart';

class AllTask extends StatefulWidget {
  const AllTask({Key? key}) : super(key: key);

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  User? user = Auth().currentUser;
  List<String> list = <String>['All', 'Completed', 'Uncompleted'];
  String dropdownValue = "All";

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
              bool status = value['status'].toLowerCase() == 'true';
              if (dropdownValue == 'All' ||
                  (dropdownValue == 'Completed' && status) ||
                  (dropdownValue == 'Uncompleted' && !status)) {
                tasks.add(Task(
                  id: key,
                  title: value['title'],
                  description: value['description'],
                  dueDate: DateTime.parse(value['dueDate']),
                  dueTime: convertTime(value),
                  status: status,
                  createdAt: DateTime.parse(value['createdAt']),
                  updatedAt: DateTime.parse(value['updatedAt']),
                ));
              }
            });
          }

          return Scaffold(
              body: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'All Tasks',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButton(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.filter_list),
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                  borderRadius: BorderRadius.circular(10),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                                height: screenHeight * 0.4,
                                child: ListView.builder(
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) {
                                    Task task = tasks[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showUpdateTaskDialog(context, task);
                                      },
                                      child: Card(
                                        color: task.status
                                            ? Colors.green[50]
                                            : Colors.red[50],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            task.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: task.status
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.redAccent,
                                            ),
                                          ),
                                          trailing: MSHCheckbox(
                                            size: 25,
                                            value: task.status == true,
                                            colorConfig: MSHColorConfig
                                                .fromCheckedUncheckedDisabled(
                                              checkedColor: Theme.of(context)
                                                  .primaryColor,
                                              uncheckedColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            style:
                                                MSHCheckboxStyle.fillScaleColor,
                                            onChanged: (selected) {
                                              // Update the data in the Firebase database
                                              userRef
                                                  .child(task.id.toString())
                                                  .update({
                                                'status': selected.toString()
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ]))));
        });
  }
}

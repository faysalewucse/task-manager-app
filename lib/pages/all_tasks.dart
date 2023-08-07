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
                            const Text(
                              'All Tasks',
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
                                      onTap: () {
                                        showUpdateTaskDialog(context, task);
                                      },
                                      child: Card(
                                        color: Colors.green[50],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            task.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
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

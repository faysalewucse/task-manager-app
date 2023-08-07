import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:task_manager/pages/all_tasks.dart';
import 'package:task_manager/pages/home_page.dart';
import 'package:task_manager/pages/user_profile.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
     void onTabChange(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

     final List<Widget> widgetOptions = <Widget>[
      HomePage(onTabChange: onTabChange),
      const AllTask(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
        body: Center(
          child: widgetOptions.elementAt(_selectedIndex),
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
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },),
        )
    );
  }
}

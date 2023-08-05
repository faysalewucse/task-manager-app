import 'package:flutter/material.dart';
import 'package:task_manager/auth/auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future logOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            logOut();
          },
          icon: const Icon(Icons.login_outlined),
          label: const Text('Logout'),
        ),
      ),
    );
  }
}

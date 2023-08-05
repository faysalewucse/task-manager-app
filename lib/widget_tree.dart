import 'package:flutter/cupertino.dart';
import 'package:task_manager/auth/auth.dart';
import 'package:task_manager/layout.dart';
import 'package:task_manager/pages/login_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeLayout();
          } else {
            return const LoginPage();
          }
        });
  }
}

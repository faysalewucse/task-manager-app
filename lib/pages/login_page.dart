import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/auth/auth.dart';
import 'package:task_manager/components/auth_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginPage = true;
  bool loading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginPage = true;
  }

  @override
  Widget build(BuildContext context) {
    Future signInWithEmailAndPassword() async {
      try {
        await Auth().signInWithEmailAndPassword(
            email: email.text, password: password.text);
        loading = false;
      } on FirebaseAuthException catch (e) {
        _showToast(e.message!);
        setState(() {
          loading = false;
        });
      }
    }

    Future createUserWithEmailAndPassword() async {
      try {
        await Auth().createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        setState(() {
          loading = false;
        });
      } on FirebaseAuthException catch (e) {
        _showToast(e.message!);
        setState(() {
          loading = false;
        });
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/login_page.png"),
                    width: 100,
                  ),
                  Text(
                    "Task Manager",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  AuthFormField(
                      controller: email,
                      hintText: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 10,
                  ),
                  AuthFormField(
                    controller: password,
                    hintText: 'Password',
                    icon: Icons.lock,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 2,
                            padding: const EdgeInsets.all(10.0)),
                        onPressed: loading
                            ? () {}
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  loginPage
                                      ? signInWithEmailAndPassword()
                                      : createUserWithEmailAndPassword();
                                } else {
                                  _formKey.currentState!.save();
                                }
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (loading)
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 25,
                                width: 25,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            Text(
                              loginPage ? 'Login' : 'Register',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          loginPage
                              ? 'Don`t have an account?'
                              : 'Already have an account?',
                          style: const TextStyle(color: Colors.black)),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            loginPage = !loginPage;
                          });
                        },
                        child: Text(loginPage ? 'Register' : 'Login',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 2,
                            backgroundColor: Colors.white),
                        onPressed: () {},
                        icon: const Icon(LineIcons.googlePlus),
                        label: const Text('Continue with Google')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showToast(String message){
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
    );
  }
}

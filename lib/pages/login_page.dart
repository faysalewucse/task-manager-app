import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginPage = true;
  }

  @override
  Widget build(BuildContext context) {

    String? errorMessage = '';
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    Future signInWithEmailAndPassword() async {
      print("Called");
      try {
        await Auth().signInWithEmailAndPassword(
            email: email.text, password: password.text);
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }
    
    Future createUserWithEmailAndPassword() async {
      print("Called");
      try {
        await Auth().signInWithEmailAndPassword(
            email: email.text, password: password.text);
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }

    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
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
                    controller: email, hintText: 'Email', icon: Icons.email),
                const SizedBox(
                  height: 10,
                ),
                AuthFormField(
                    controller: password,
                    hintText: 'Password',
                    icon: Icons.lock),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 2,
                      ),
                      onPressed: () {
                        if(loginPage){
                          signInWithEmailAndPassword();
                        }
                        else{
                          createUserWithEmailAndPassword();
                        }
                      },
                      child: Text(
                        loginPage ? 'Login' : 'Register',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
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
                      // child: const Text(
                      //   'LOGIN',
                      //   style: TextStyle(color: Colors.white, fontSize: 20),
                      // )),
                      icon: const Icon(LineIcons.googlePlus),
                      label: const Text('Continue with Google')),
                ),
                Text(errorMessage!, style: TextStyle(color: Colors.redAccent),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

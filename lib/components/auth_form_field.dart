import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;

  const AuthFormField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.icon,
      required this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: keyboardType == TextInputType.visiblePassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.white),
      controller: controller,
      validator: (String? value) {
        if (value!.isEmpty) {
          return '$hintText is blank';
        } else if (hintText == "Email" &&
            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return 'Enter valid email!';
        } else if (hintText == "Password" && value.length < 6) {
          return 'Password should be at least 6 characters';
        }
        return null;
      },
    );
  }
}

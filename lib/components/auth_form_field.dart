import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  const AuthFormField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      maxLines: null,
      validator: (String? value) {
        return (value == null) ? '$hintText is blank' : null;
      },
    );
  }
}

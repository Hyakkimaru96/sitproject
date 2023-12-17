import 'package:flutter/material.dart';

Widget textFieldPrettier(
  BuildContext context,
  TextEditingController controller,
  String labelText, {
  bool isPassword = false,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
    child: Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
        ),
        controller: controller,
        obscureText: isPassword,
        onChanged: (value) {
          // You can add a simple validation logic here
          if (value.trim().isEmpty) {
            // If the input is empty, you can handle it accordingly
            // For example, you can set an error message or disable the submit button
            print('Input cannot be empty for $labelText');
          } else {
            // If the input is not empty, you can handle it accordingly
          }
        },
      ),
    ),
  );
}

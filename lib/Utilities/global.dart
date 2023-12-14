import 'package:flutter/material.dart';

Widget textFieldPrettier(BuildContext context,
    TextEditingController nameController, String labelText) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
    child: Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).colorScheme.primary))),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
        ),
        controller: nameController,
      ),
    ),
  );
}

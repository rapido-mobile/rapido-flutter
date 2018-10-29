import 'package:flutter/material.dart';

class TypedInputField extends StatelessWidget {
  final String fieldName;
  final String label;
  final Function onSaved;

  TypedInputField(this.fieldName, {@required this.label, @required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
              decoration: InputDecoration(labelText: label),
              onSaved: (String value) {
                this.onSaved(value);
              });
  }
}
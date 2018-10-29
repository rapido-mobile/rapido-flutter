import 'package:flutter/material.dart';

class TypedInputField extends StatelessWidget {
  final String fieldName;
  final String label;
  final Function onSaved;

  TypedInputField(this.fieldName, {@required this.label, @required this.onSaved});

  @override
  Widget build(BuildContext context) {
    if(fieldName.toLowerCase().endsWith("count")){
    return TextFormField(
              decoration: InputDecoration(labelText: label),
              keyboardType: TextInputType.number,
              onSaved: (String value) {
                int v = int.parse(value);
                this.onSaved(v);
              });
    }
    return TextFormField(
              decoration: InputDecoration(labelText: label),
              onSaved: (String value) {
                this.onSaved(value);
              });
  }
}
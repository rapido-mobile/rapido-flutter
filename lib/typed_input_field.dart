import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class TypedInputField extends StatelessWidget {
  final String fieldName;
  final String label;
  final Function onSaved;
  final dynamic initialValue;

  TypedInputField(this.fieldName,
      {@required this.label, @required this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    if (fieldName.toLowerCase().endsWith("count")) {
      return TextFormField(
        decoration: InputDecoration(labelText: label),
        initialValue: initialValue.toString(),
        onSaved: (String value) {
          this.onSaved(int.parse(value));
        },
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      );
    }
    if (fieldName.toLowerCase().endsWith("date")) {
      return DateTimePickerFormField(
        format: DateFormat.yMd(),
        decoration: InputDecoration(labelText: label),
        dateOnly: true,
        onSaved: (DateTime value) {
          DateFormat formatter = DateFormat.yMd();
          String v = formatter.format(value);
          this.onSaved(v);
        },
        initialValue: _formatInitialDateTime(),
      );
    }
    return TextFormField(
        decoration: InputDecoration(labelText: label),
        initialValue: initialValue,
        onSaved: (String value) {
          this.onSaved(value);
        });
  }

  DateTime _formatInitialDateTime() {
    if (initialValue == null) {
      return DateTime.now();
    } else {
      DateTime dt = DateFormat.yMd().parse(initialValue);
      return dt;
    }
  }
}
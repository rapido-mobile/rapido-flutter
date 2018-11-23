import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

/// Given a field name, returns an appropriately configured FormField,
/// possibly parented by another widget.
/// Types are inferred from fieldNames.
/// Field name ends in | inferred type
/// ends in "count" -> integer
/// ends in "date" -> date
/// All other fields return strings.
class TypedInputField extends StatelessWidget {
  /// The name of the field, used to calculate which type of input to return
  final String fieldName;

  /// The label to display in the UI for the specified fieldName
  final String label;

  /// Call back function invoked when the Form parent of the FormField is
  /// saved. The value returned is determined by the type of the field.
  final Function onSaved;

  /// The initial value to display in the FormField.
  final dynamic initialValue;

  TypedInputField(this.fieldName,
      {@required this.label, @required this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    if (fieldName.toLowerCase().endsWith("count")) {
      return _getIntegerFormField();
    }
    if (fieldName.toLowerCase().endsWith("date")) {
      return _getDateFormField();
    }
    return _getTextFormField();
  }

  TextFormField _getTextFormField() {
    return TextFormField(
        decoration: InputDecoration(labelText: label),
        initialValue: initialValue,
        onSaved: (String value) {
          this.onSaved(value);
        });
  }

  DateTimePickerFormField _getDateFormField() {
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

  TextFormField _getIntegerFormField() {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue == null ? "0" : initialValue.toString(),
      onSaved: (String value) {
        this.onSaved(int.parse(value));
      },
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: false),
    );
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

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
      return Row(
        children: [
          Text(label),
          IntegerFormField(
              onSaved: onSaved,
              initialValue: initialValue == null ? 0 : initialValue),
        ],
      );
    }
    if (fieldName.toLowerCase().endsWith("date")) {
      return DateTimePickerFormField(
        format: DateFormat("EEEE, MMMM d, yyyy "),
        decoration: InputDecoration(labelText: label),
        dateOnly: true,
        onSaved: (DateTime value) {
          DateFormat formatter = DateFormat.yMd();
          String v = formatter.format(value);
          this.onSaved(v);
        },
      );
    }
    return TextFormField(
        decoration: InputDecoration(labelText: label),
        initialValue: initialValue,
        onSaved: (String value) {
          this.onSaved(value);
        });
  }
}

class IntegerFormField extends FormField<int> {
  IntegerFormField(
      {FormFieldSetter<int> onSaved,
      FormFieldValidator<int> validator,
      int initialValue = 0,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<int> state) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      state.didChange(state.value - 1);
                    },
                  ),
                  Text(state.value.toString()),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      state.didChange(state.value + 1);
                    },
                  ),
                ],
              );
            });
}

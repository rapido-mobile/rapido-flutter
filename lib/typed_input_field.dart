import 'package:flutter/material.dart';

class TypedInputField extends StatelessWidget {
  final String fieldName;
  final String label;
  final Function onSaved;

  TypedInputField(this.fieldName,
      {@required this.label, @required this.onSaved});

  @override
  Widget build(BuildContext context) {
    if (fieldName.toLowerCase().endsWith("count")) {
      return Row(
        children: [
          Text(label),
          IntegerFormField(onSaved: onSaved),
        ],
      );
    }
    return TextFormField(
        decoration: InputDecoration(labelText: label),
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

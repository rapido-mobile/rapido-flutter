import 'package:flutter/material.dart';

/// A form field for boolean values.
class BooleanFormField extends StatefulWidget {
  /// The name of the field, used to calculate which type of input to return
  final String fieldName;

  /// The label to display in the UI for the specified fieldName
  final String label;

  /// Call back function invoked when the Form parent of the FormField is
  /// saved. The value returned is determined by the type of the field.
  final Function onSaved;

  /// The initial value to display in the FormField. Should be a string that is
  /// either a path to an image on the device, or a URL to an image on the
  /// internet.
  final bool initialValue;

  const BooleanFormField(this.fieldName,
      {Key key, this.label, @required this.onSaved, this.initialValue: false})
      : super(key: key);

  _BooleanFormFieldState createState() => _BooleanFormFieldState();
}

class _BooleanFormFieldState extends State<BooleanFormField> {
  bool currentValue;
  @override
  void initState() {
    if (widget.initialValue == null) {
      currentValue = false;
    } else {
      currentValue = widget.initialValue;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: ((FormFieldState<bool> state) {
        return Row(children: [
          Text(widget.label),
          Checkbox(
            value: currentValue,
            onChanged: ((bool newVal) {
              setState(() {
                currentValue = newVal;
              });
            }),
          ),
        ]);
      }),
      onSaved: (bool val) {
        widget.onSaved(currentValue);
      },
    );
  }
}

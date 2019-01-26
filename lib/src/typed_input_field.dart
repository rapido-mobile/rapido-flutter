import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'map_point_form_field.dart';
import 'image_form_field.dart';
import 'boolean_form_field.dart';

/// Given a field name, returns an appropriately configured FormField,
/// possibly parented by another widget.
/// Types are inferred from fieldNames.
/// Field name ends in | inferred type
/// ends in "count" -> integer
/// ends in "date" -> date
/// ends in "datetime" -> date and time
/// ends in "latlong" -> latitude and longitude
/// ends in "image" -> image
/// ends in "text" -> multiline string
/// ends in "?" -> boolean
/// All other fields return a single line text input field.
class TypedInputField extends StatelessWidget {
  /// Optional Custom format string for reading, writing, and
  /// display DateTime objects which include both date and time
  final String dateTimeFormat;

  /// Optional Custom format string for reading, writing, and
  /// display DateTime objects which include only a date
  final String dateFormat;

  /// A list of options typically used for rendering
  /// input widgets.
  final Map<String, dynamic> fieldOptions;

  final String _dateTimeFormat = "EEE, MMM d, y H:mm:s";
  final String _dateFormat = "yMd";

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
      {@required this.label,
      @required this.onSaved,
      this.initialValue,
      this.dateTimeFormat,
      this.dateFormat, this.fieldOptions});

  @override
  Widget build(BuildContext context) {
    print(fieldOptions);

    if (fieldName.toLowerCase().endsWith("count")) {
      return _getIntegerFormField();
    }
    if (fieldName.toLowerCase().endsWith("datetime")) {
      String f = dateTimeFormat == null ? _dateTimeFormat : dateTimeFormat;
      return _getDateTimeFormField(f, false, context);
    }
    if (fieldName.toLowerCase().endsWith("date")) {
      String f = dateFormat == null ? _dateFormat : dateFormat;
      return _getDateTimeFormField(f, true, context);
    }
    if (fieldName.toLowerCase().endsWith("latlong")) {
      //work around json.decode reading _InternalHashMap<String, dynamic>
      Map<String, double> v;
      if (initialValue != null) {
        v = Map<String, double>.from(initialValue);
      }
      return MapPointFormField(fieldName, label: label, initialValue: v,
          onSaved: (Map<String, double> value) {
        this.onSaved(value);
      });
    }

    if (fieldName.toLowerCase().endsWith("image")) {
      return ImageFormField(
        fieldName,
        initialValue: initialValue,
        label: label,
        onSaved: (String value) {
          this.onSaved(value);
        },
      );
    }

    if (fieldName.toLowerCase().endsWith("text")) {
      return _getTextFormField(lines: 10);
    }

    if (fieldName.toLowerCase().endsWith("?")) {
      return BooleanFormField(
        fieldName,
        label: label,
        initialValue: initialValue,
        onSaved: (bool value) {
          this.onSaved(value);
        },
      );
    }

    return _getTextFormField();
  }

  TextFormField _getTextFormField({int lines: 1}) {
    return TextFormField(
        maxLines: lines,
        decoration: InputDecoration(labelText: label),
        initialValue: initialValue,
        onSaved: (String value) {
          this.onSaved(value);
        });
  }

  DateTimePickerFormField _getDateTimeFormField(
      formatString, dateOnly, BuildContext context) {
    DateFormat format = DateFormat(formatString);
    return DateTimePickerFormField(
      format: format,
      decoration: InputDecoration(labelText: label),
      dateOnly: dateOnly,
      onSaved: (DateTime value) {
        String v = format.format(value);
        this.onSaved(v);
      },
      initialValue: _formatInitialDateTime(format),
    );
  }

  DateTime _formatInitialDateTime(DateFormat format) {
    if (initialValue == null) {
      return DateTime.now();
    } else {
      DateTime dt = format.parse(initialValue);
      return dt;
    }
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
}

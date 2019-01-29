import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:rapido/rapido.dart';
import 'package:numberpicker/numberpicker.dart';

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
/// Optionally, you can provide an appropriate FieldOptions subclass object
/// to specify how to render the field. 
class TypedInputField extends StatelessWidget {

  /// Options for configuring the InputField
  final FieldOptions fieldOptions;

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
      this.fieldOptions});

  @override
  Widget build(BuildContext context) {
    if (fieldOptions != null) {
      if (fieldOptions.runtimeType == InputListFieldOptions) {
        return _getListPickerFormField(fieldOptions);
      }
    }
    if (fieldName.toLowerCase().endsWith("count")) {
      return _getIntegerFormField();
    }
    if (fieldName.toLowerCase().endsWith("datetime")) {
      String dateTimeFormat;
      if (fieldOptions != null) {
        dateTimeFormat = _getFormatStringFromOptions();
      }
      if (dateTimeFormat == null) {
        dateTimeFormat = _dateTimeFormat;
      }
      return _getDateTimeFormField(dateTimeFormat, false, context);
    }
    if (fieldName.toLowerCase().endsWith("date")) {
      String dateFormat;
      if (fieldOptions != null) {
        dateFormat = _getFormatStringFromOptions();
      }
      if (dateFormat == null) {
        dateFormat = _dateFormat;
      }
      return _getDateTimeFormField(dateFormat, true, context);
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

  String _getFormatStringFromOptions() {
    String dateTimeFormat;
    if (fieldOptions.runtimeType == DateTimeFieldOptions) {
      DateTimeFieldOptions fo = fieldOptions as DateTimeFieldOptions;
      dateTimeFormat = fo.formatString;
    }
    return dateTimeFormat;
  }

  Widget _getTextFormField({int lines: 1}) {
    return TextFormField(
        maxLines: lines,
        decoration: InputDecoration(labelText: label),
        initialValue: initialValue,
        onSaved: (String value) {
          this.onSaved(value);
        });
  }

  ListPickerFormField _getListPickerFormField(
      InputListFieldOptions fieldOptions) {
    return ListPickerFormField(
      documentList: DocumentList(fieldOptions.documentType),
      displayField: fieldOptions.displayField,
      valueField: fieldOptions.valueField,
      label: label,
      initiValue: initialValue,
      onSaved: (dynamic value) {
        this.onSaved(value);
      },
    );
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

  Widget _getIntegerFormField() {
    if (fieldOptions != null) {
      if (fieldOptions.runtimeType == IntegerPickerFieldOptions) {
        IntegerPickerFieldOptions fo =
            fieldOptions as IntegerPickerFieldOptions;

        if (fo.minimum != null && fo.maximum != null) {
          return IntegerPickerFormField(
            label: label,
            initialValue: initialValue,
            fieldOptions: fieldOptions,
            onSaved: (int val) {
              this.onSaved(val);
            },
          );
        }
      }
    }

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

/// A FormField for choosing integer values, rendered
/// as a spinning chooser. You must provide a map
/// of field options that include min and max, in the form of:
/// fieldOptions: {"min":0,"max":10}, in order to provide a
/// FormField limited to 0 through 10.
class IntegerPickerFormField extends StatefulWidget {
  const IntegerPickerFormField({
    Key key,
    @required this.initialValue,
    @required this.fieldOptions,
    @required this.onSaved,
    this.label,
  }) : super(key: key);

  final IntegerPickerFieldOptions fieldOptions;
  final Function onSaved;
  final int initialValue;
  final String label;

  @override
  _IntegerPickerFormFieldState createState() {
    return new _IntegerPickerFormFieldState();
  }
}

class _IntegerPickerFormFieldState extends State<IntegerPickerFormField> {
  int _currentValue;

  @override
  void initState() {
    widget.initialValue == null
        ? _currentValue = widget.fieldOptions.minimum
        : _currentValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormFieldCaption(widget.label),
        FormField(
          builder: (FormFieldState<int> state) {
            return NumberPicker.integer(
              initialValue: _currentValue,
              maxValue: widget.fieldOptions.maximum,
              minValue: widget.fieldOptions.minimum,
              onChanged: (num val) {
                setState(() {
                  _currentValue = val;
                });
              },
            );
          },
          onSaved: (int val) {
            widget.onSaved(_currentValue);
          },
        ),
      ],
    );
  }
}

/// A widget for captioning fields in DocumentForm and DocumentPage.
class FormFieldCaption extends StatelessWidget {
  const FormFieldCaption(this.label, {Key key}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    if (label == null) return Container();
    return Text(
      label,
      style: Theme.of(context).textTheme.caption,
      textAlign: TextAlign.start,
    );
  }
}

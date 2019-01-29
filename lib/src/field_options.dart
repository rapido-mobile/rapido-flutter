class FieldOptions {}

class InputListFieldOptions extends FieldOptions {
  final String documentType;
  final String displayField;
  final String valueField;

  InputListFieldOptions(this.documentType, this.displayField, this.valueField);
}

class IntegerPickerFieldOptions extends FieldOptions {
  final int minimum;
  final int maximum;

  IntegerPickerFieldOptions(this.minimum, this.maximum);
}

class DateTimeFieldOptions extends FieldOptions {
  final String formatString;

  DateTimeFieldOptions(this.formatString);

}

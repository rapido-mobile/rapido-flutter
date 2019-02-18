import 'package:rapido/rapido.dart';

/// FieldOptions base class. This class is abstract, so
/// should not be initialized directly
abstract class FieldOptions {}

/// Forces any input field to be rendered as a ListPicker
class InputListFieldOptions extends FieldOptions {
  final DocumentList documentList;
  final String displayField;
  final String valueField;

  InputListFieldOptions(
      {this.documentList, this.displayField, this.valueField});
}

/// Field options for amount fields, currently ignored by the android
///  keyboard.
class AmountFieldOptions extends FieldOptions {
  final bool allowNegatives;

  AmountFieldOptions({this.allowNegatives});
}

/// Forces an input field to be rendered as an IntegerPicker.
class IntegerPickerFieldOptions extends FieldOptions {
  final int minimum;
  final int maximum;

  IntegerPickerFieldOptions({this.minimum, this.maximum});
}

/// Provides options for configuring a Date or DateTime form field
class DateTimeFieldOptions extends FieldOptions {
  final String formatString;

  DateTimeFieldOptions({this.formatString});
}

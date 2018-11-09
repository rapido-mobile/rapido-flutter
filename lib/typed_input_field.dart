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

class IntegerFormField extends StatefulWidget {
  final int initialValue;
  final Function onSaved;
  IntegerFormField({this.initialValue, this.onSaved});

  _IntegerFormFieldState createState() => _IntegerFormFieldState();
}

class _IntegerFormFieldState extends State<IntegerFormField> {
 int value;

  @override
  initState(){
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      onSaved: (int v){
        print("In value: $v");
        print("Entered value: $value");
        widget.onSaved(value);
      },
      builder: (FormFieldState<int> state) {
      return SizedBox(
        width: 50.0,
        child: TextField(
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: false),
          controller: TextEditingController(
            text: value.toString(),
          ),
          onChanged: (String v) {
            value = int.parse(v);
          },
        ),
      );
    });
  }
  // IntegerFormField(
  //     {FormFieldSetter<int> onSaved,
  //     FormFieldValidator<int> validator,
  //     int initialValue = 0,
  //     bool autovalidate = false})
  //     : super(
  //           onSaved: onSaved,
  //           validator: validator,
  //           initialValue: initialValue,
  //           autovalidate: autovalidate,
  //           builder: (FormFieldState<int> state) {
  //             return Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 IconButton(
  //                   icon: Icon(Icons.remove),
  //                   onPressed: () {
  //                     state.didChange(state.value - 1);
  //                   },
  //                 ),
  //                 SizedBox(
  //                   width: 50.0,
  //                   child: TextField(
  //                       keyboardType: TextInputType.numberWithOptions(
  //                           signed: false, decimal: false),
  //                       controller: TextEditingController(
  //                           text: initialValue.toString(),
  //                           ),
  //                           onChanged: (String value){
  //                             state.didChange(int.parse(value));
  //                           },),
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.add),
  //                   onPressed: () {
  //                     state.didChange(state.value + 1);
  //                   },
  //                 ),
  //               ],
  //             );
  //           });

}

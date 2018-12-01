import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPointFormField extends StatefulWidget {
  /// The name of the field, used to calculate which type of input to return
  final String fieldName;

  /// The label to display in the UI for the specified fieldName
  final String label;

  /// Call back function invoked when the Form parent of the FormField is
  /// saved. The value returned is determined by the type of the field.
  final Function onSaved;

  /// The initial value to display in the FormField.
  final Map<String, double> initialValue;
  MapPointFormField(this.fieldName,
      {@required this.label, @required this.onSaved, this.initialValue});

  _MapPointFormFieldState createState() => _MapPointFormFieldState();
}

class _MapPointFormFieldState extends State<MapPointFormField> {
  @override
  Widget build(BuildContext context) {
    print("--------------");
    print(widget.initialValue);

    print(
        "${widget.initialValue["longitude"]},${widget.initialValue["latitude"]}");
    return TextFormField(
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: IconButton(
            icon: Icon(Icons.map),
            onPressed: () {},
          ),
        ),
        initialValue:
            "${widget.initialValue["longitude"]}:${widget.initialValue["latitude"]}",
        onSaved: (String value) {
          widget.onSaved(value);
        });
  }
}

import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';
import 'typed_input_field.dart';

class PersistedModelForm extends StatefulWidget {
  final PersistedModel model;
  final index;

  PersistedModelForm(this.model, {this.index});
  @override
  _PersistedModelFormState createState() => _PersistedModelFormState();
}

class _PersistedModelFormState extends State<PersistedModelForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> newData = {};

  List<Widget> _buildFormFields(BuildContext context) {
    List<Widget> fields = [];
    widget.model.labels.keys.forEach((String label) {
      dynamic initialValue;
      if (widget.index != null) {
        initialValue =
            widget.model.data[widget.index][widget.model.labels[label]];
      }
      fields.add(
        Container(
          padding: EdgeInsets.all(10.0),
          child: TypedInputField(widget.model.labels[label],
              label: label,
              initialValue: initialValue, onSaved: (dynamic value) {
            newData[widget.model.labels[label]] = value;
          }),
          margin: EdgeInsets.all(10.0),
        ),
      );
    });

    fields.add(Container(
      padding: EdgeInsets.only(left: 100.0, right: 100.0),
      child: RaisedButton(
          child: Text(widget.index == null ? "Add" : "Save"),
          onPressed: () {
            formKey.currentState.save();
            if (widget.index == null) {
              widget.model.add(newData);
            } else {
              widget.model.update(widget.index, newData);
            }
            Navigator.pop(context);
          }),
    ));
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    String titleText = widget.index == null ? "Add" : "Edit";
    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: Form(
        key: formKey,
        child: ListView(
          children: _buildFormFields(context),
        ),
      ),
    );
  }
}

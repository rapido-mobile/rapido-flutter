import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';
import 'typed_input_field.dart';

class PersistedModelForm extends StatelessWidget {
  final PersistedModel model;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> _newData = {};

  PersistedModelForm(this.model, {@required this.formKey });

  List<Widget> _buildFormFields(BuildContext context) {
    print("Global Key: " + formKey.toString());
    List<Widget> fields = [];
    model.labels.keys.forEach((String label) {
      fields.add(
          TypedInputField(
              model.labels[label],
              label: label,
              onSaved: (dynamic value) {
                _newData[model.labels[label]] = value;
              }),
      );
    });

    fields.add(Container(
          padding: EdgeInsets.only(left: 100.0, right: 100.0),
          child: RaisedButton(
          child: Text("Add"),
          onPressed: () {
            formKey.currentState.save();
            model.add(_newData);
            Navigator.pop(context);
          }),
    ));
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Form")),
      body: Form(
        key: formKey,
        child: ListView(
          children: _buildFormFields(context),
        ),
      ),
    );
  }
}

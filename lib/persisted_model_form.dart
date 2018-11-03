import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';
import 'typed_input_field.dart';


class PersistedModelForm extends StatelessWidget {
  final PersistedModel model;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> newData;

  PersistedModelForm(this.model, {@required this.formKey, @required this.newData }){
  }

  List<Widget> _buildFormFields(BuildContext context) {
    List<Widget> fields = [];
    model.labels.keys.forEach((String label) {
      fields.add(
          TypedInputField(
              model.labels[label],
              label: label,
              onSaved: (dynamic value) {
                newData[model.labels[label]] = value;
              }),
      );
    });

    fields.add(Container(
          padding: EdgeInsets.only(left: 100.0, right: 100.0),
          child: RaisedButton(
          child: Text("Add"),
          onPressed: () {
            formKey.currentState.save();
            model.add(newData);
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

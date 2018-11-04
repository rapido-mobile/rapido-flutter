import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';
import 'typed_input_field.dart';

class PersistedModelForm extends StatelessWidget {
  final PersistedModel model;
  final GlobalKey<FormState> formKey;
  final index;
  final Map<String, dynamic> newData;

  PersistedModelForm(this.model,
      {@required this.formKey, @required this.newData, this.index});

  List<Widget> _buildFormFields(BuildContext context) {
    List<Widget> fields = [];
    model.labels.keys.forEach((String label) {
      dynamic initialValue;
      if (index != null) {
        initialValue = model.data[index][model.labels[label]];
      }
      fields.add(
        TypedInputField(model.labels[label],
            label: label, initialValue: initialValue, onSaved: (dynamic value) {
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
            if (index == null) {
              model.add(newData);
            }
            else {
              //model.upate
            }
            Navigator.pop(context);
          }),
    ));
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    String titleText = index == null ? "Add" : "Edit";
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

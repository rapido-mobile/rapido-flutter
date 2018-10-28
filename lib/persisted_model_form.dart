import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';

class PersistedModelForm extends StatelessWidget {
  final PersistedModel model;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _newData = {};
  PersistedModelForm(this.model);

  List<Widget> _buildFormFields() {

    List<Widget> fields = [];
    model.labels.keys.forEach((String label) {
      fields.add(
        TextFormField(
          decoration: InputDecoration(labelText: label),
          onSaved: (String value){
            _newData[model.labels[label]] = value;
          }
        ),
      );
    });
    fields.add(RaisedButton(child: Text("Add"), onPressed: _submitForm));
    return fields;
  }

  void _submitForm() {
    _formKey.currentState.save();
    model.add(_newData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Form")),
      body: Form(
        key: _formKey,
        child: ListView(children: _buildFormFields()),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';

class PersistedModelForm extends StatelessWidget {
  final PersistedModel model;
  final _formKey = GlobalKey<FormState>();

  PersistedModelForm(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Form")),
      body: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              initialValue: "A",
            ),
            TextFormField(
              initialValue: "B",
            ),
          ])),
    );
  }
}

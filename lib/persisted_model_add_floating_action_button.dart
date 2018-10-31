import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';
import 'package:a2s_widgets/persisted_model_form.dart';

class PersistedModelAddFloatingActionButton extends StatelessWidget {
  final PersistedModel model;
  final GlobalKey<FormState> k = GlobalKey<FormState>();
  PersistedModelAddFloatingActionButton(this.model);

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return PersistedModelForm(model, formKey: k);
          }),
        );
      },
    );
  }
}

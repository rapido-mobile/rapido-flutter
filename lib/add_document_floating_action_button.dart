import 'package:flutter/material.dart';
import 'package:a2s_widgets/document_set.dart';
import 'package:a2s_widgets/document_form.dart';

class AddDocumentFloatingActionButton extends StatelessWidget {
  final DocumentSet documentSet;
  AddDocumentFloatingActionButton(this.documentSet);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return DocumentForm(documentSet);
          }),
        );
      },
    );
  }
}

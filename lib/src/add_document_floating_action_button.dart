import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';

/// A floating button that invokes a form to add a new
/// document to a DocumentList. Typically used in Scaffolds.
class AddDocumentFloatingActionButton extends StatelessWidget {
  /// The DocumentList on which the button and forms that it invokes act.
  final DocumentList documentList;
  AddDocumentFloatingActionButton(this.documentList);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return DocumentForm(documentList);
          }),
        );
      },
    );
  }
}

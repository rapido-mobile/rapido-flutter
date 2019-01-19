import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

/// A floating button that invokes a form to add a new
/// document to a DocumentList. Typically used in Scaffolds.
class AddDocumentFloatingActionButton extends StatelessWidget {
  /// The DocumentList on which the button and forms that it invokes act.
  final DocumentList documentList;

  /// Optional string to describe the add action.
  /// If supplied, the fab will use an extended fab, with the label.
  final String addActionLabel;

  final BoxDecoration formDecoration;

  final BoxDecoration formFieldDecoration;

  AddDocumentFloatingActionButton(this.documentList,
      {this.addActionLabel, this.formDecoration, this.formFieldDecoration});

  @override
  Widget build(BuildContext context) {
    if (addActionLabel == null) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return DocumentForm(
                documentList,
                decoration: formDecoration,
                fieldDecoration: formFieldDecoration,
              );
            }),
          );
        },
      );
    } else {
      return FloatingActionButton.extended(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return DocumentForm(
                documentList,
                decoration: formDecoration,
                fieldDecoration: formFieldDecoration,
              );
            }),
          );
        },
        label: Text(addActionLabel),
      );
    }
  }
}

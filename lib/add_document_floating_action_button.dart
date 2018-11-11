import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';
import 'package:rapido/document_form.dart';

class AddDocumentFloatingActionButton extends StatelessWidget {
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
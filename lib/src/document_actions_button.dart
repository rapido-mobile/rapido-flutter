import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

/// A button that will add editing options UI to a documentList document.
/// It creates a builder button with a contextial menu, that allows editing
/// or deleting of the document by passing in the documentList and the index
/// of the document to edit.
class DocumentActionsButton extends StatelessWidget {
  /// The DocumentList on which the button and forms that it invokes act.
  final DocumentList documentList;

  /// The index of document in documentList on which button acts.
  final int index;

  final BoxDecoration formDecoration;

  final BoxDecoration formFieldDecoration;

  DocumentActionsButton(this.documentList,
      {@required this.index, this.formDecoration, this.formFieldDecoration});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        onSelected: (int action) {
          switch (action) {
            case 0:
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return DocumentForm(
                    documentList,
                    document: documentList[index],
                    decoration: formDecoration,
                    fieldDecoration: formFieldDecoration,
                  );
                },
              ));
              break;
            case 1:
              documentList.removeAt(index);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
              PopupMenuItem<int>(
                value: 0,
                child: Icon(Icons.edit),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Icon(Icons.delete),
              ),
            ]);
  }
}

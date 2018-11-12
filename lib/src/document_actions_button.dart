import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';
import 'package:rapido/document_widgets.dart';

/// A button that will add editing options UI to a documentList document.
/// It creates a builder button with a contextial menu, that allows editing
/// or deleting of the document by passing in the documentList and the index
/// of the document to edit.
class DocumentActionsButton extends StatelessWidget {
  final DocumentList documentList;
  final int index;

  DocumentActionsButton(this.documentList, {@required this.index});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        onSelected: (int action) {
          switch (action) {
            case 0:
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return DocumentForm(
                  documentList,
                  index: index,
                );
              }));
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

import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';
import 'package:rapido/document_form.dart';

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

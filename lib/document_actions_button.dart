import 'package:flutter/material.dart';
import 'package:a2s_widgets/document_list.dart';
import 'package:a2s_widgets/document_form.dart';

class DocumentActionsButton extends StatelessWidget {
  final DocumentList documentSet;
  final int index;

  DocumentActionsButton(this.documentSet, {@required this.index});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        onSelected: (int action) {
          switch (action) {
            case 0:
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return DocumentForm(
                  documentSet,
                  index: index,
                );
              }));
              break;
            case 1:
              documentSet.removeAtIndex(index);
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

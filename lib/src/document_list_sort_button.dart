import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';

class DocumentListSortButton extends StatefulWidget {
  final DocumentList documentList;

  DocumentListSortButton(this.documentList);

  @override
  _DocumentListSortButtonState createState() => _DocumentListSortButtonState();
}

class _DocumentListSortButtonState extends State<DocumentListSortButton> {
  SortOrder currentSortOrder = SortOrder.ascending;
  String currentFieldName = "";
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        icon: Icon(Icons.sort),
        onSelected: (String fieldName) {
          //toggle the sort if the same fieldname was selected multiple times
          if (fieldName == currentFieldName) {
            currentSortOrder == SortOrder.ascending
                ? currentSortOrder = SortOrder.descending
                : currentSortOrder = SortOrder.ascending;
          } else {
            currentSortOrder = SortOrder.ascending;
          }
          widget.documentList.sortByField(fieldName, sortOrder: currentSortOrder);
          currentFieldName = fieldName;
        },
        itemBuilder: (BuildContext context) {
          List<PopupMenuItem<String>> fieldButtons = [];
          widget.documentList.labels.forEach((String label, String fieldName) {
            fieldButtons.add(PopupMenuItem<String>(
                value: fieldName,
                child: ListTile(
                  title: Text(label),
                )));
          });
          return fieldButtons;
        });
  }
}

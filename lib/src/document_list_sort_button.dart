import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

/// A button that adds sorting to a DocumentList. Useful for adding
/// sorting functionality to a DocumentListView.
class DocumentListSortButton extends StatefulWidget {
  /// The DocumentList to be sorted
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
          widget.documentList
              .sortByField(fieldName, sortOrder: currentSortOrder);
          currentFieldName = fieldName;
        },
        itemBuilder: (BuildContext context) {
          List<String> unsortable = ["image", "latlong"];
          List<PopupMenuItem<String>> fieldButtons = [];
          widget.documentList.labels.forEach((String label, String fieldName) {
            bool addToList = true;
            unsortable.forEach((String s) {
              if (fieldName.toLowerCase().endsWith(s)) {
                addToList = false;
              }
            });
            if (addToList) {
              fieldButtons.add(PopupMenuItem<String>(
                  value: fieldName,
                  child: ListTile(
                    title: Text(label),
                  )));
            }
          });
          return fieldButtons;
        });
  }
}

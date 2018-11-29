import 'package:flutter/material.dart';
import 'package:rapido/documents.dart';

/// A dynamically generated page for viewing document contents
class DocumentPage extends StatelessWidget {
  /// The DocumentList on which the forms acts.
  final DocumentList documentList;
  final Document document;

  DocumentPage(this.documentList, this.document);

  List<Widget> _buildFormFields(BuildContext context) {
    List<Widget> fields = [];

    // creat a form field for each support label
    if (document["subtitle"] != null) {
      fields.add(Text(
        document["subtitle"].toString(),
        softWrap: true,
        style: Theme.of(context).textTheme.headline,
      ));
    }
    documentList.labels.keys.forEach((String label) {
      String fieldName = documentList.labels[label];
      if (fieldName != "title" && fieldName != "subtitle") {
        // add to the array of input fields
        fields.add(
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(children: [
              Text(label),
              Text(document[fieldName].toString()),
            ]),
            margin: EdgeInsets.all(10.0),
          ),
        );
      }
    });

    return fields;
  }

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    document["title"] != null
        ? titleWidget = Text(document["title"])
        : titleWidget = Icon(Icons.book);
    return Scaffold(
      appBar: AppBar(title: titleWidget),
      body: ListView(
        children: _buildFormFields(context),
      ),
    );
  }
}

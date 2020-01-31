import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

/// Experimental support for auto-generated view of the contents of
/// a Document. This is meant to be a read only view, and returns a
/// Scaffold, so is mostly meant to be used in page navigation.
class DocumentPage extends StatelessWidget {
  /// Map the UI labels to include in the DocumentPage to fields
  /// in the document.
  final Map<String, String> labels;

  /// The Document object to display
  final Document document;

  /// A decoration for the entire DocumentPage
  final BoxDecoration decoration;

  /// A decoration to apply to each field in the DocumentPage
  final BoxDecoration fieldDecoration;

  /// A DocumentForm to enable editing the Document
  /// If not null, it will add an editing action to title bar
  /// of the page, which will push a DocumentForm on the navigation
  /// stack.
  final DocumentForm documentForm;

  DocumentPage(
      {@required this.labels,
      @required this.document,
      this.decoration,
      this.fieldDecoration,
      this.documentForm});

  List<Widget> _buildFormFields(BuildContext context) {
    List<Widget> fields = [];

    // creat a form field for each support label
    if (document["subtitle"] != null) {
      fields.add(
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Container(
            decoration: fieldDecoration,
            child: ListTile(
                title: Text(
              document["subtitle"].toString(),
              softWrap: true,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline,
            )),
          ),
        ),
      );
    }
    labels.keys.forEach((String label) {
      String fieldName = labels[label];

      if (fieldName != "title" && fieldName != "subtitle") {
        // add to the array of input fields
        fields.add(
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: fieldDecoration,
              child: ListTile(
                subtitle: Text(label),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TypedDisplayField(
                      fieldName: fieldName,
                      document: document,
                    ),
                  ],
                ),
              ),
            ),
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
      appBar: AppBar(
        title: titleWidget,
        actions: documentForm != null
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return documentForm;
                    }));
                  },
                )
              ]
            : null,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            children: _buildFormFields(context),
          ),
        ),
        decoration: decoration,
      ),
    );
  }
}

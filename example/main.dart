import 'package:flutter/material.dart';
import 'package:rapido/documents.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapido Demo',
      home: RapidoExample(title: 'Rapdio'),
    );
  }
}

class RapidoExample extends StatefulWidget {
  RapidoExample({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RapidoExampleState createState() => _RapidoExampleState();
}

class _RapidoExampleState extends State<RapidoExample> {

  // Create a Document with a documentType string of your choice.
  // Include a map of lables for the fields in the document type.
  final DocumentList documentList = DocumentList(
    "task list",
    labels: {"Date": "date", "Title": "task", "Priorty": "pri count"},
  );

  // Build a DocumentListScaffold to provide the UI for users to
  // create, edit, and delete documents
  @override
  Widget build(BuildContext context) {
    return DocumentListScaffold(
      documentList,
      title: "Tasks",
    );
  }
}
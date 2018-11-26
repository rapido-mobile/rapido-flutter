import 'package:flutter/material.dart';
import 'package:rapido/documents.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DocumentList docs = DocumentList("taskList",
      labels: {
        "Date": "date", // will create a date field in forms
        "Task": "task", // will create a text field in forms
        "Priority": "pri count", // will create an integer field in forms
        "Note": "note" // will create a text field in forms
      },
      onLoadComplete: (DocumentList list) {});

  @override
  Widget build(BuildContext context) {
    return DocumentListScaffold(
      docs,
      title: "Tasks",

      // supply a custom builder instead of using the
      // default ListTiles in the DocumentListView
      customItemBuilder: customItemBuilder,
    );
  }

  // helper function to supply the color
  Color _calculateColor(Document doc) {
    final int pri = doc["pri count"];
    if (pri < 3) {
      return Colors.red;
    } else if (pri < 7) {
      return Colors.yellow;
    }
    return Colors.green;
  }

  // Custom builder creates a cart from the DocumentList
  Widget customItemBuilder(int index, Document doc, BuildContext context) {
    return Card(
      color: _calculateColor(doc),
      child: Column(children: [
        Center(
          child: Text(
            doc["task"],
            style: Theme.of(context).textTheme.display1,
          ),
        ),
        Center(
          child: Text(
            doc["note"].toString(),
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              doc["date"].toString(),
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              doc["pri count"].toString(),
              style: Theme.of(context).textTheme.title,
            ),

            // Reuse the DocumentActionsButton widget from the
            // rapido library
            DocumentActionsButton(docs, index: index),
          ],
        ),
      ]),
    );
  }
}

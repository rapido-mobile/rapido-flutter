import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

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
  DocumentList docs = DocumentList(
    "taskList",

    // Labels to use in the UI
    labels: {
      "Date": "date", // will create a date field in forms
      "Task": "title", // will create a text field in forms
      "Priority": "pri count", // will create an integer field in forms
      "Note": "note" // will create a text field in forms
    },
  );

  @override
  Widget build(BuildContext context) {
    return DocumentListScaffold(
      docs,
      title: "Tasks",
      // set the order and fields to display in the title of the default ListTyle
      titleKeys: ["title", "date", "pri count"],

      // set the field to use for the subtitle in default ListTile
      subtitleKey: "note",

      // respond to tapping in the default ListTyle
      onItemTap: (int index) {
        print("${docs[index]["task"]} tapped");
      },

      // widget to display when there is no data entered
      emptyListWidget: Center(
        child: Text("Click the plus button to get started"),
      ),

      // set a decoration of the default ListView
      decoration: BoxDecoration(color: Colors.grey),
    );
  }
}

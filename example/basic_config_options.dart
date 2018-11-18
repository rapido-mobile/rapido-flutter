import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';

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
      "Date": "date",
      "Task": "task",
      "Priority": "pri count",
      "Note": "note"
    },
    // if there are existing documents on disk, onLoadComplete
    // will fire after they are all loaded.
    // Loading is async, so UI may be rendered before loading is complete
    onLoadComplete: (DocumentList list) {
      list.sort((t1, t2) => t1["pri count"] - (t2["pri count"]));
    },
  );

  @override
  Widget build(BuildContext context) {
    docs.sort((t1, t2) => t1["pri count"] - (t2["pri count"]));

    return DocumentListScaffold(
      docs,
      title: "Tasks",
      // set the order and fields to display in the title of the default ListTyle
      titleKeys: ["task", "date", "pri count"],

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
      decoration: BoxDecoration(color:Colors.grey),
    );
  }
}

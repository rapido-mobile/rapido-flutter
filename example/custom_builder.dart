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
  DocumentList docs = DocumentList("taskList", labels: {
    "Date": "date", // will create a date field in forms
    "Task": "task", // will create a text field in forms
    "Priority": "pri count", // will create an integer field in forms
    "Note": "note" // will create a text field in forms
  }, onLoadComplete: (DocumentList list) {
    list.sort((t1, t2) => t1["pri count"] - (t2["pri count"]));
  });

  @override
  Widget build(BuildContext context) {
    docs.sort((t1, t2) => t1["pri count"] - (t2["pri count"]));

    return DocumentListScaffold(
      docs,
      title: "Tasks",
      
      // don't use default ListTiles by supplying a custom
      //builder
      customItemBuilder: customItemBuilder,
    );
  }

  // helper function to supply the color
  Color _calculateColor(index) {
    final int pri = docs[index]["pri count"];
    if(pri < 3){return Colors.red;}
    else if(pri < 7){return Colors.yellow;}
    return Colors.green;
  }

  // Custom builder creates a cart from the DocumentList
  Widget customItemBuilder(int index) {
    return Card(
      color: _calculateColor(index),
      child: Column(children: [
        Center(
          child: Text(
            docs[index]["task"],
            style: Theme.of(context).textTheme.display1,
          ),
        ),
        Center(
          child: Text(
            docs[index]["note"].toString(),
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              docs[index]["date"].toString(),
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              docs[index]["pri count"].toString(),
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

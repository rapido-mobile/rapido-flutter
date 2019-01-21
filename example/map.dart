import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocumentMapView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'DocumentMapView Demo Page'),
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
  DocumentList documentList = DocumentList(
    "Mapped Task List",
    labels: {
      "Task": "title",
      "Note": "subtitle",
      "Priority": "pri count",
      "Date": "date",
      "Location": "latlong",
    },
  );

  @override
  Widget build(BuildContext context) {
    return DocumentListScaffold(
      documentList,
      titleKeys: ["date", "title", "pri count"],
      subtitleKey: "subtitle",
      additionalActions: <Widget>[
        IconButton(
          icon: Icon(Icons.map),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return DocumentListMapView(documentList);
            }));
          },
        ),
      ],
    );
  }
}

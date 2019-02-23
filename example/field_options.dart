import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

void main() => runApp(Tasker());

class Tasker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskerHomePage(),
    );
  }
}

class TaskerHomePage extends StatefulWidget {
  TaskerHomePage({Key key}) : super(key: key);

  @override
  _TaskerHomePageState createState() => _TaskerHomePageState();
}

class _TaskerHomePageState extends State<TaskerHomePage> {
  DocumentList documentList;
  @override
  initState() {
    DocumentList inputList = DocumentList(
      "task types",
      initialDocuments: [
        Document(initialValues: {"name": "Shopping"}),
        Document(initialValues: {"name": "House Work"}),
        Document(initialValues: {"name": "Errands"}),
        Document(initialValues: {"name": "School"}),
      ],
    );

    documentList = DocumentList(
      "tasker",
      labels: {
        "Priority": "count",
        "Category": "type",
      },
      fieldOptionsMap: {
        "type": InputListFieldOptions(
          documentList: inputList,
          displayField: "name",
          valueField: "name",
        ),
        "count": IntegerPickerFieldOptions(minimum: 1, maximum: 10),
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DocumentListScaffold(
      documentList,
    );
  }
}

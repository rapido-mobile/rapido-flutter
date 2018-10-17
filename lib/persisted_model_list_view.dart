import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:a2s_widgets/persisted_model.dart';

class PersistedModelListView extends StatelessWidget {
final String documentType;

PersistedModelListView(this.documentType);

@override
Widget build(BuildContext context){
  return ScopedModelDescendant<PersistedModel>(
          builder: (context, child, model) {
          return ListView.builder(
              itemCount: model.data.length + 1,
              itemBuilder: (context, i) {
                if (i < model.data.length) {
                  return ListTile(
                    title: Text(model.data[i]["str"]),
                    trailing: RaisedButton(
                      child: Icon(Icons.delete),
                      onPressed: () {model.delete(i);},
                    ),
                  );
                } else {
                  return RaisedButton(child: Text("Add"), onPressed: () {});
                }
              });
          });
}
}
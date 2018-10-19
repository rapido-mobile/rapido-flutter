import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:a2s_widgets/persisted_model.dart';

class PersistedModelListView extends StatelessWidget {
  final PersistedModel model;
  final String titleKey;
  PersistedModelListView(this.model, {@required this.titleKey});

  String _getTitle(Map<String, dynamic> map) {
    if (map.containsKey(titleKey)) {
      return map[titleKey];
    }
    print("$titleKey not found in map, returning empty string");
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      child: ScopedModelDescendant<PersistedModel>(
          builder: (context, child, model) {
        return ListView.builder(
            itemCount: model.data.length + 1,
            itemBuilder: (context, index) {
              if (index < model.data.length) {
                return Dismissible(
                    child: ListTile(title: Text(_getTitle(model.data[index]))),
                    onDismissed: (direction) {
                      model.delete(index);
                    },
                    key: Key(model.data[index]["_id"]));
              } else {
                return RaisedButton(child: Text("Add"), onPressed: () {});
              }
            });
      }),
      model: model
    );
  }
}

import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';

class PersistedModelListView extends StatefulWidget {
  final PersistedModel model;
  final List<String> titleKeys;
  final String subtitleKey;
  final Function onItemTap;

  PersistedModelListView(this.model,
      {@required this.titleKeys, this.subtitleKey, this.onItemTap});

  _PersistedModelListViewState createState() => _PersistedModelListViewState();
}

class _PersistedModelListViewState extends State<PersistedModelListView> {
  List<Map<String, dynamic>> data;

  @override
  initState() {
    super.initState();
    data = widget.model.data;
  }

  List<Widget> _buildTitleRowChildren(Map<String, dynamic> map) {
    List<Widget> cells = [];
    widget.titleKeys.forEach((String key) {
      if (map.containsKey(key)) {
        cells.add(Text(map[key].toString()));
      }
    });
    return cells;
  }

  Widget _buildSubtitle(Map<String, dynamic> map) {
    if (widget.subtitleKey == null) return null;
    if (!map.containsKey(widget.subtitleKey)) return null;
    return Text(map[widget.subtitleKey].toString());
  }

  @override
  Widget build(BuildContext context) {
    widget.model.onChanged = (List<Map<String, dynamic>> newData) {
      setState(() {
        data = newData;
      });
    };
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Dismissible(
            child: ListTile(
              onTap: () {
                if (widget.onItemTap != null) {
                  widget.onItemTap(index);
                }
              },
              title: Row(
                children: _buildTitleRowChildren(data[index]),
              ),
              subtitle: _buildSubtitle((data[index])),
            ),
            onDismissed: (direction) {
              widget.model.delete(index);
            },
            key: Key(data[index]["_id"]),
          );
        });
  }
}

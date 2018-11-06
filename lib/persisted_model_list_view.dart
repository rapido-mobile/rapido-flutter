import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';
import 'package:a2s_widgets/persisted_model_form.dart';

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
        cells.add(
          Text(
            map[key].toString(),
            softWrap: true,
            style: Theme.of(context).textTheme.subhead,
          ),
        );
      }
    });
    return cells;
  }

  Widget _buildSubtitle(Map<String, dynamic> map) {
    if (widget.subtitleKey == null) return null;
    if (!map.containsKey(widget.subtitleKey)) return null;
    return Text(map[widget.subtitleKey].toString());
  }

  void _createEditForm(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return PersistedModelForm(
        widget.model,
        index: index,
      );
    }));
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
          return ListTile(
            onTap: () {
              if (widget.onItemTap != null) {
                widget.onItemTap(index);
              }
            },
            title: Row(
              children: _buildTitleRowChildren(data[index]),
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
            ),
            subtitle: _buildSubtitle(data[index]),
            trailing: PopupMenuButton<Function>(
                onSelected: (Function action) {
                  action(index);
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuItem<Function>>[
                      PopupMenuItem<Function>(
                        value: _createEditForm,
                        child: Icon(Icons.edit),
                      ),
                      PopupMenuItem<Function>(
                        value: widget.model.delete,
                        child: Icon(Icons.delete),
                      ),
                    ]),
          );
        });
  }
}

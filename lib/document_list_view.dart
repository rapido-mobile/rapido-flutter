import 'package:flutter/material.dart';
import 'package:a2s_widgets/document_set.dart';
import 'package:a2s_widgets/persisted_model_list_item_action_button.dart';

class DocumentListView extends StatefulWidget {
  final DocumentSet model;
  final List<String> titleKeys;
  final String subtitleKey;
  final Function onItemTap;
  final Function customItemBuilder;
  final Widget emptyListWidget;

  DocumentListView(this.model,
      {@required this.titleKeys,
      this.subtitleKey,
      this.onItemTap,
      this.customItemBuilder,
      this.emptyListWidget});

  _DocumentListViewState createState() => _DocumentListViewState();
}

class _DocumentListViewState extends State<DocumentListView> {
  List<Map<String, dynamic>> data;

  @override
  initState() {
    super.initState();
    data = widget.model.documents;
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

  @override
  Widget build(BuildContext context) {
    widget.model.onChanged = (List<Map<String, dynamic>> newData) {
      setState(() {
        data = newData;
      });
    };

    if (widget.model.documents.length == 0 && widget.emptyListWidget != null) {
      print("${widget.model.documents.length} : ${widget.emptyListWidget}");
        return widget.emptyListWidget;
    }

    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return buildListItem(index);
        });
  }

  Widget buildListItem(int index) {
    if (widget.customItemBuilder == null) {
      return _defaultListTile(index);
    } else {
      return widget.customItemBuilder(index);
    }
  }

  Container _defaultListTile(int index) {
    return Container(
      decoration: null,
      child: ListTile(
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
          trailing:
              PersistedModelListItemActionButton(widget.model, index: index)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';

/// A ListView that automatically displays the contents of a DocumentList.
/// By default it includes an action button that allows deletion and
/// editing of each document. To replace the default ListTile,
/// supply a customIemBuilder. The look and feel of the ListView
/// can be customized by providing a decoration. emptyListWidget, if supplied,
/// will display in the case that the DocumentList is empty.
class DocumentListView extends StatefulWidget {
  
  /// The DocumentList rendered by the DocumentListView
  final DocumentList documentList;

  /// A list of keys for spefifying which values to use in the title of the 
  /// default ListTile in the DocumentListView, and the order in which to 
  /// show them. Ignored when customItemBuilder is used.
  final List<String> titleKeys;

  /// The key specifying which value in the documents to use when
  /// rendering the default ListTiles. Ignored when customItemBuilder is used.
  final String subtitleKey;

  /// A call back function to call when the default ListTile in the 
  /// DocumentListView is tapped by the user. 
  /// Ignored when customItemBuilder is used.
  final Function onItemTap;

  /// A call back function for building custom widgets for the DocumentListView,
  /// rather than the default ListTile. Like a normal builder, it receives a
  /// integer as an index into the associated DocumentList and should return a
  /// widget.
  /// Widget customItemBuilder(int index) {/* create and return a custom widget 
  /// for documentList[index]*/}
  final Function customItemBuilder;

  /// A widget to display when the DocumentListView is empty (when the 
  /// DocumentList.length == 0)
  final Widget emptyListWidget;

  DocumentListView(this.documentList,
      {this.titleKeys,
      this.subtitleKey,
      this.onItemTap,
      this.customItemBuilder,
      this.emptyListWidget});

  _DocumentListViewState createState() => _DocumentListViewState();
}

class _DocumentListViewState extends State<DocumentListView> {
  DocumentList data;

  @override
  initState() {
    super.initState();
    data = widget.documentList;
  }

  List<Widget> _buildTitleRowChildren(Map<String, dynamic> map) {
    List<Widget> cells = [];
    List<String> titleKeys = widget.titleKeys;
    if (titleKeys == null) {

      titleKeys = widget.documentList.labels.values.toList();
    }
    titleKeys.forEach((String key) {
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
    widget.documentList.onChanged = (DocumentList newData) {
      setState(() {
        data = newData;
      });
    };

    if (widget.documentList.length == 0 && widget.emptyListWidget != null) {
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
          trailing: DocumentActionsButton(widget.documentList, index: index)),
    );
  }
}

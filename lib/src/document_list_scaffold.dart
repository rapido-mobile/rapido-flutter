import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';

// import 'package:rapido/document_list_view.dart';
// import 'package:rapido/add_document_floating_action_button.dart';

/// Convenience UI for creating all create, update, and delete UI
/// for a given DocumentList. It will generate a default ListView.
/// Can be customized with a customIemBuilder and/or a decoration.
/// decoration, customItemBuild, and emptuListWidget, are passed
/// through to the DocumentListView.
class DocumentListScaffold extends StatefulWidget {
  /// The DocumentList rendered by the DocumentListScaffold
  final DocumentList documentList;

  /// The title to display in the header of the scaffold.
  final String title;

  /// A call back function to call when the default ListTile in the
  /// DocumentListView is tapped by the user.
  /// Ignored when customItemBuilder is used.
  final Function onItemTap;

  /// A list of keys for spefifying which values to use in the title of the
  /// default ListTile in the DocumentListView, and the order in which to
  /// show them. Ignored when customItemBuilder is used.
  final List<String> titleKeys;

  /// The key specifying which value in the documents to use when
  /// rendering the default ListTiles. Ignored when customItemBuilder is used.
  final String subtitleKey;

  /// A box decoration, that, if supplied will be applied to the DocumentListView.
  final BoxDecoration decoration;

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

  DocumentListScaffold(this.documentList,
      {@required this.title,
      this.onItemTap,
      @required this.titleKeys,
      this.subtitleKey,
      this.decoration,
      this.customItemBuilder,
      this.emptyListWidget});

  _DocumentListScaffoldState createState() => _DocumentListScaffoldState();
}

class _DocumentListScaffoldState extends State<DocumentListScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[DocumentListSortButton(widget.documentList)],
      ),
      body: Container(
        child: DocumentListView(
          widget.documentList,
          titleKeys: widget.titleKeys,
          subtitleKey: widget.subtitleKey,
          onItemTap: widget.onItemTap,
          customItemBuilder: widget.customItemBuilder,
          emptyListWidget: widget.emptyListWidget,
        ),
        decoration: widget.decoration,
      ),
      floatingActionButton:
          AddDocumentFloatingActionButton(widget.documentList),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

// import 'package:rapido/document_list_view.dart';
// import 'package:rapido/add_document_floating_action_button.dart';

/// Convenience UI for creating all create, update, and delete UI
/// for a given DocumentList. It will generate a default ListView.
/// Can be customized with a customIemBuilder and/or a decoration.
/// decoration, customItemBuild, and emptuListWidget, are passed
/// through to the DocumentListView.
///
/// To ignore item taps, set showDocumentPageOnTap to false.
/// To set a special behavion for item taps, set onItemTap.
class DocumentListScaffold extends StatefulWidget {
  /// The DocumentList rendered by the DocumentListScaffold
  final DocumentList documentList;

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

  /// Title to display on the scaffold. If not supplied, DocumentListScaffold
  /// will simply use the documentType property of the DocumentList.
  final String title;

  /// Optional string to pass to pass to the AddDocumentFloatingActionButton.
  /// If supplied, the fab will use an extended fab, with the label.
  final String addActionLabel;

  /// Adds widgets to the titlebar, typically IconButtons.
  final List<Widget> additionalActions;

  /// If true, tapping on the item will automatically display a
  /// DocumentPage for the item. Defaults to true. Ignored if
  /// onItemTap is not null.
  final bool showDocumentPageOnTap;

  final BoxDecoration formDecoration;

  final BoxDecoration formFieldDecoration;

  final BoxDecoration documentPageDecoration;

  final BoxDecoration documentFieldDecoration;

  DocumentListScaffold(
    this.documentList, {
    this.title,
    this.onItemTap,
    @required this.titleKeys,
    this.subtitleKey,
    this.decoration,
    this.customItemBuilder,
    this.emptyListWidget,
    this.addActionLabel,
    this.additionalActions,
    this.formDecoration,
    this.formFieldDecoration,
    this.documentPageDecoration,
    this.documentFieldDecoration,
    this.showDocumentPageOnTap: true,
  });

  _DocumentListScaffoldState createState() => _DocumentListScaffoldState();
}

class _DocumentListScaffoldState extends State<DocumentListScaffold> {
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = <Widget>[
      DocumentListSortButton(widget.documentList)
    ];
    if (widget.additionalActions != null) {
      actions += widget.additionalActions;
    }
    String _title =
        widget.title != null ? widget.title : widget.documentList.documentType;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: actions,
      ),
      body: Container(
        child: DocumentListView(
          widget.documentList,
          titleKeys: widget.titleKeys,
          subtitleKey: widget.subtitleKey,
          onItemTap: widget.onItemTap,
          customItemBuilder: widget.customItemBuilder,
          emptyListWidget: widget.emptyListWidget,
          showDocumentPageOnTap: widget.showDocumentPageOnTap,
          formDecoration: widget.formDecoration,
          formFieldDecoration: widget.formFieldDecoration,
          documentPageDecoration: widget.documentPageDecoration,
          documentFieldDecoration: widget.documentFieldDecoration,
        ),
        decoration: widget.decoration,
      ),
      floatingActionButton: AddDocumentFloatingActionButton(
        widget.documentList,
        addActionLabel: widget.addActionLabel,
        formDecoration: widget.formDecoration,
        formFieldDecoration: widget.formFieldDecoration,
      ),
    );
  }
}

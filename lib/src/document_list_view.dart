import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

/// A ListView that automatically displays the contents of a DocumentList.
/// By default it includes an action button that allows deletion and
/// editing of each document. To replace the default ListTile,
/// supply a customItemBuilder. The look and feel of the ListView
/// can be customized by providing a decoration. emptyListWidget, if supplied,
/// will display in the case that the DocumentList is empty.
class DocumentListView extends StatefulWidget {
  /// The DocumentList rendered by the DocumentListView
  final DocumentList documentList;

  /// A list of keys for specifying which values to use in the title of the
  /// default ListTile in the DocumentListView, and the order in which to
  /// show them. Ignored when customItemBuilder is used.
  final List<String> titleKeys;

  /// The key specifying which value in the documents to use when
  /// rendering the default ListTiles. Ignored when customItemBuilder is used.
  /// By default, a field called "subtitle" will be used as a subtitle, but
  /// this property will overwrite that behavior
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

  /// Show default document page when the list item is tapped.
  /// Ignored if onItemTap callback is set.
  final bool showDocumentPageOnTap;

  /// Control the scroll axis. Defaults to Vertical. Ignored if
  /// customItemBuilder is null.
  final Axis scrollDirection;

  /// A BoxDecoration for the whole list view
  final BoxDecoration decoration;

  /// A BoxDecoration for automatically generated forms
  final BoxDecoration formDecoration;

  /// A BoxDecoration for automatically generated pages
  final BoxDecoration documentPageDecoration;

  /// A BoxDecoration for each field in a DocumentForm
  final BoxDecoration formFieldDecoration;

  /// A BoxDecoration for each field in a DocumentPage
  final BoxDecoration documentFieldDecoration;

  DocumentListView(this.documentList,
      {this.titleKeys,
      this.subtitleKey,
      this.onItemTap,
      this.customItemBuilder,
      this.emptyListWidget,
      this.decoration,
      this.formDecoration,
      this.documentPageDecoration,
      this.formFieldDecoration,
      this.documentFieldDecoration,
      this.showDocumentPageOnTap: true,
      this.scrollDirection: Axis.vertical});

  _DocumentListViewState createState() => _DocumentListViewState();
}

class _DocumentListViewState extends State<DocumentListView> {
  DocumentList data;
  Axis _scrollDirection;

  @override
  initState() {
    data = widget.documentList;
    if (widget.customItemBuilder == null &&
        widget.scrollDirection == Axis.horizontal) {
      print("""
WARNING: DocumentListView defaults do not support horizontal scroll
direction. To use scrollDirection of horizontal, you must supply a
customItemBuilder to the DocumentListView.
""");
      _scrollDirection = Axis.vertical;
    } else {
      _scrollDirection = widget.scrollDirection;
    }
    super.initState();
  }

  List<Widget> _buildTitleRowChildren(Document doc) {
    List<Widget> cells = [];
    List<String> titleKeys = widget.titleKeys;
    if (titleKeys == null) {
      titleKeys = widget.documentList.labels.values.toList();
    }
    titleKeys.forEach((String key) {
      bool skip = false;

      if (doc.containsKey(key)) {
        // if the user hasn't defined a subtitle key
        // then assume they want a field call "subtitle"
        // to be in the subtitle, and not in the title

        if (widget.subtitleKey == null) {
          if (key == "subtitle") {
            skip = true;
          }
        }
        // don't try to display null or empty value
        if (!skip && (doc[key] != null && doc[key] != "")) {
          // find if there is label for the key
          // this is a little confusing because the key is actual a value
          // in the documentList.labels map, and the key in that map
          // is the string that we want to display
          String lbl;
          if (widget.documentList.labels.containsValue(key)) {
            Map<String, String> reversed =
                widget.documentList.labels.map((k, v) => MapEntry(v, k));
            lbl = reversed[key];
          }
          cells.add(
            TypedDisplayField(
              document: doc,
              fieldName: key,
              boxSize: 100.00,
              label: lbl,
            ),
          );
        }
      }
    });
    return cells;
  }

  Widget _buildSubtitle(Document doc) {
    // check if the a subtitle key was defined
    if (widget.subtitleKey != null) {
      // check if this particular doc contains that key,
      // and if so, return it
      if (!doc.containsKey(widget.subtitleKey)) return null;
      return Text(doc[widget.subtitleKey].toString());
    }
    // check if there is a subtitle field in the doc
    // and if so, fall back to using it
    else if (doc.containsKey("subtitle")) {
      return Text(doc["subtitle"]);
    } else
      return null; // nothing was found to use for a subtitle
  }

  @override
  Widget build(BuildContext context) {
    widget.documentList.addListener(() {
      setState(() {});
    });

    if (widget.documentList.length == 0 && widget.emptyListWidget != null) {
      return widget.emptyListWidget;
    }

    return Container(
      decoration: widget.decoration,
      child: ListView.builder(
          scrollDirection: _scrollDirection,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return buildListItem(index);
          }),
    );
  }

  Widget buildListItem(int index) {
    if (widget.customItemBuilder == null) {
      return _defaultListTile(index);
    } else {
      if (widget.titleKeys != null) {
        print("""
Warning: DocumentListView.customItemBuilder and titleKeys are both set.
Ignoring titleKeys property.
        """);
      }
      if (widget.subtitleKey != null) {
        print("""
Warning: DocumentListView.customItemBuilder and subtitleKey are both set.
Ignoring subtitleKey property.
        """);
      }
      return widget.customItemBuilder(
          index, widget.documentList[index], context);
    }
  }

  Container _defaultListTile(int index) {
    return Container(
      decoration: null,
      child: ListTile(
          onTap: () {
            // If the user has passed in an onTap callback then use that.
            // Otherwise, if the user has not disabled showing the DocumentPage
            // then push a DocumentPage.
            if (widget.onItemTap != null) {
              widget.onItemTap(widget.documentList[index]);
            } else if (widget.showDocumentPageOnTap) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return DocumentPage(
                    labels: widget.documentList.labels,
                    document: widget.documentList[index],
                    decoration: widget.documentPageDecoration,
                    fieldDecoration: widget.documentFieldDecoration,
                  );
                }),
              );
            }
          },
          title: Row(
            children: _buildTitleRowChildren(data[index]),
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          subtitle: _buildSubtitle(data[index]),
          trailing: DocumentActionsButton(
            widget.documentList,
            index: index,
            formDecoration: widget.formDecoration,
            formFieldDecoration: widget.formFieldDecoration,
          )),
    );
  }
}

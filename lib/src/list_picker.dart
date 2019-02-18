import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

const double _ITEM_EXTENT = 50.0;
const int _VISIBLE_ITEMS_COUNT = 3;

/// Widget that displays a scrolling list of items, allowing users
/// to choose one item from that list.
class ListPicker extends StatefulWidget {
  /// The DocumentList that will supply the list of values to
  /// display in the picker
  final DocumentList documentList;

  /// The name of the field in the DocumentList to display in the picker
  final String displayField;

  /// Callback for when the user has chosen a new value in the picker.
  /// Returns the chosen Document.
  final Function onChanged;

  /// Initial index in the DocumentList. Defaults to 0.
  final int initialIndex;

  /// fires when the DocumentList has loaded, and the widget
  /// has loaded the list. Typically used for tests.
  final Function onListLoaded;

  const ListPicker(
      {Key key,
      @required this.documentList,
      @required this.displayField,
      this.onChanged,
      this.initialIndex,
      this.onListLoaded})
      : super(key: key);

  @override
  _ListPickerState createState() => _ListPickerState();
}

class _ListPickerState extends State<ListPicker> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex == null ? 0 : widget.initialIndex;
    widget.documentList.onLoadComplete = (DocumentList list) {
      setState(() {});
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.documentList.documentsLoaded) {
      return Center(child: Text("this is from the picker"));
    }

    ScrollController scrollController = ScrollController(
        initialScrollOffset: (_ITEM_EXTENT * currentIndex) + _ITEM_EXTENT);
    ListView listView = ListView(
      controller: scrollController,
      itemExtent: _ITEM_EXTENT,
      children: _buildChildren(context),
    );

    return Container(
      height: _VISIBLE_ITEMS_COUNT * _ITEM_EXTENT,
      child: NotificationListener(
        child: listView,
        onNotification: (Notification notification) {
          if (notification is ScrollNotification) {
            int intIndexOfMiddleElement =
                (notification.metrics.pixels / _ITEM_EXTENT).round();
            intIndexOfMiddleElement = intIndexOfMiddleElement.clamp(
                0, widget.documentList.length - 1);
            if (currentIndex != intIndexOfMiddleElement) {
              setState(() {
                currentIndex = intIndexOfMiddleElement;
              });
              widget.onChanged(widget.documentList[currentIndex]);
            }
          }
          return true;
        },
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    TextStyle defaultStyle = Theme.of(context).textTheme.body1;
    TextStyle selectedStyle = Theme.of(context)
        .textTheme
        .headline
        .copyWith(color: Theme.of(context).accentColor);
    List<Widget> widgets = List<Widget>();
    widgets.add(Container());
    for (int i = 0; i < widget.documentList.length; i++) {
      Document doc = widget.documentList[i];
      if (doc[widget.displayField] != null) {
        widgets.add(
          Center(
            child: Text(
              doc[widget.displayField].toString(),
              style: i == currentIndex ? selectedStyle : defaultStyle,
            ),
          ),
        );
      }
    }

    widgets.add(Container());
    return widgets;
  }
}

/// A FormField for a ListPicker
class ListPickerFormField extends StatefulWidget {
  /// The DocumentList that will supply the list of values to
  /// display in the picker
  final DocumentList documentList;

  /// The name of the field in the DocumentList to display in the picker
  final String displayField;

  /// The name of the field in DocumentList that provides the tracked value
  final String valueField;

  /// Label for the FormField
  final String label;

  /// Function callback for onSaved, typically called by a DocumentForm
  final Function onSaved;

  /// Sets the initial state of the FormField, if any
  final dynamic initiValue;

  const ListPickerFormField(
      {Key key,
      @required this.documentList,
      @required this.displayField,
      this.label,
      this.onSaved,
      this.initiValue,
      @required this.valueField})
      : super(key: key);

  @override
  _ListPickerFormField createState() => _ListPickerFormField();
}

class _ListPickerFormField extends State<ListPickerFormField> {
  int initialIndex;
  dynamic currentValue;

  @override
  initState() {
    if (widget.documentList.documentsLoaded) {
      initializeValues();
    }
    widget.documentList.onLoadComplete = (DocumentList list) {
      setState(() {
        initializeValues();
      });
    };
    super.initState();
  }

  initializeValues() {
    if (widget.initiValue != null) {
      for (int i = 0; i < widget.documentList.length; i++) {
        if (widget.documentList[i][widget.valueField] == widget.initiValue) {
          currentValue = widget.initiValue;
          initialIndex = i;
          break;
        }
      }
    } else {
      currentValue = widget.documentList[0][widget.valueField];
      initialIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.documentList.documentsLoaded) {
      return CircularProgressIndicator();
    }
    return Column(
      children: <Widget>[
        FormFieldCaption(widget.label),
        FormField(
          builder: (FormFieldState<dynamic> state) {
            return ListPicker(
              documentList: widget.documentList,
              displayField: widget.displayField,
              initialIndex: initialIndex,
              onChanged: (Document doc) {
                currentValue = doc[widget.valueField];
              },
            );
          },
          onSaved: (dynamic val) {
            widget.onSaved(currentValue);
          },
        ),
      ],
    );
  }
}

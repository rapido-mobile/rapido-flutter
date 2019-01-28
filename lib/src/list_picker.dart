import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

const double _ITEM_EXTENT = 50.0;
const int _VISIBLE_ITEMS_COUNT = 3;

class ListPicker extends StatefulWidget {
  final DocumentList documentList;
  final String displayField;
  final Function onChanged;
  final int initialIndex;

  const ListPicker(
      {Key key,
      @required this.documentList,
      @required this.displayField,
      this.onChanged,
      this.initialIndex})
      : super(key: key);

  @override
  _ListPickerState createState() => _ListPickerState();
}

class _ListPickerState extends State<ListPicker> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex == null ? 0 : widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.documentList.onLoadComplete = (DocumentList list) {
      setState(() {});
    };
    if (widget.documentList.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
    ScrollController scrollController =
        ScrollController(initialScrollOffset: (_ITEM_EXTENT * currentIndex) + _ITEM_EXTENT);
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
              doc[widget.displayField],
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

class ListPickerFormField extends StatefulWidget {
  final DocumentList documentList;
  final String displayField;
  final String valueField;
  final String label;
  final Function onSaved;
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

  initializeValues(DocumentList list) {
    if (widget.initiValue != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i][widget.valueField] == widget.initiValue) {
          currentValue = widget.initiValue;
          initialIndex = i;
          break;
        }
      }
    } else {
      currentValue = list[0][widget.valueField];
      initialIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.documentList.onLoadComplete = (DocumentList list) {
      setState(() {
        initializeValues(list);
      });
    };
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

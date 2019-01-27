// import 'dart:math' as math;

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';
// import 'package:flutter/rendering.dart';

class ListPicker extends StatefulWidget {
  final DocumentList documentList;
  final String displayField;
  final String label;
  const ListPicker(
      {Key key,
      @required this.documentList,
      @required this.displayField,
      this.label})
      : super(key: key);

  @override
  _ListPickerState createState() => _ListPickerState();
}

class _ListPickerState extends State<ListPicker> {
  int currentIndex = 0;

  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    // widget.documentList.addListener(() {
    //   setState(() {});
    // });
    widget.documentList.onLoadComplete = (DocumentList list) {
      setState(() {});
    };
    if (widget.documentList.length == 0) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 150.0,
      child: NotificationListener(
        child: ListView(
          controller: scrollController,
          itemExtent: 50.0,
          children: _buildChildren(context),
        ),
        onNotification: (Notification notification) {
          if (notification is ScrollNotification) {
            int intIndexOfMiddleElement =
                (notification.metrics.pixels / 50.0).round();
            setState(() {
              currentIndex = intIndexOfMiddleElement;
            });
          }
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

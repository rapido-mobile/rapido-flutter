import 'package:flutter/material.dart';
import 'package:a2s_widgets/document_set.dart';
import 'package:a2s_widgets/document_list_view.dart';
import 'package:a2s_widgets/persisted_model_add_floating_action_button.dart';

class PersistedModelScaffold extends StatefulWidget {
  final DocumentSet model;
  final String title;
  final Function onItemTap;
  final List<String> titleKeys;
  final String subtitleKey;
  final BoxDecoration decoration;
  final Function customItemBuilder;
  final Widget emptyListWidget;

  PersistedModelScaffold(this.model,
      {@required this.title,
      this.onItemTap,
      @required this.titleKeys,
      this.subtitleKey,
      this.decoration,
      this.customItemBuilder,
      this.emptyListWidget});

  _PersistedModelScaffoldState createState() => _PersistedModelScaffoldState();
}

class _PersistedModelScaffoldState extends State<PersistedModelScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: DocumentListView(
          widget.model,
          titleKeys: widget.titleKeys,
          subtitleKey: widget.subtitleKey,
          onItemTap: widget.onItemTap,
          customItemBuilder: widget.customItemBuilder,
          emptyListWidget: widget.emptyListWidget,
        ),
        decoration: widget.decoration,
      ),
      floatingActionButton: PersistedModelAddFloatingActionButton(widget.model),
    );
  }
}

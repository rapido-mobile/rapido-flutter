import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model.dart';
import 'package:a2s_widgets/persisted_model_list_view.dart';
import 'package:a2s_widgets/persisted_model_add_floating_action_button.dart';

class PersistedModelScaffold extends StatefulWidget {
  final PersistedModel model;
  final String title;
  final Function onItemTap;
  final List<String> titleKeys;
  final String subtitleKey;
  final BoxDecoration decoration;

  PersistedModelScaffold(this.model,
      {@required this.title,
      this.onItemTap,
      @required this.titleKeys,
      this.subtitleKey,
      this.decoration});

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
        child: PersistedModelListView(
          widget.model,
          titleKeys: widget.titleKeys,
          subtitleKey: widget.subtitleKey,
          onItemTap: widget.onItemTap,
        ),
        decoration: widget.decoration,
      ),
      floatingActionButton: PersistedModelAddFloatingActionButton(widget.model),
    );
  }
}

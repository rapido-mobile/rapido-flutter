import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';
/// A dynamically generate form that allows creating new documents or
/// editing existing documents in a DocumentList. Specifying an index
/// for a document in a DocumentList causes the form to be in edit mode,
/// otherwise it will create a new document.
class DocumentForm extends StatefulWidget {

  /// The DocumentList on which the forms acts.
  final DocumentList documentList;

  /// If set, the index of the document within the DocumentList.
  /// If set, the form will edit the existing document, if null,
  /// the form will create a new document.
  final index;

  DocumentForm(this.documentList, {this.index});
  @override
  _DocumentFormState createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> newData = {};

  List<Widget> _buildFormFields(BuildContext context) {
    List<Widget> fields = [];
    widget.documentList.labels.keys.forEach((String label) {
      dynamic initialValue;
      if (widget.index != null) {
        initialValue =
            widget.documentList[widget.index][widget.documentList.labels[label]];
      }
      fields.add(
        Container(
          padding: EdgeInsets.all(10.0),
          child: TypedInputField(widget.documentList.labels[label],
              label: label,
              initialValue: initialValue, onSaved: (dynamic value) {
            newData[widget.documentList.labels[label]] = value;
          }),
          margin: EdgeInsets.all(10.0),
        ),
      );
    });

    fields.add(Container(
      padding: EdgeInsets.only(left: 100.0, right: 100.0),
      child: RaisedButton(
          child: Text(widget.index == null ? "Add" : "Save"),
          onPressed: () {
            formKey.currentState.save();
            if (widget.index == null) {
              widget.documentList.add(newData);
            } else {
              widget.documentList[widget.index] =  newData;
            }
            Navigator.pop(context);
          }),
    ));
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    String titleText = widget.index == null ? "Add" : "Edit";
    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: Form(
        key: formKey,
        child: ListView(
          children: _buildFormFields(context),
        ),
      ),
    );
  }
}

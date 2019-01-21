import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

/// A dynamically generate form that allows creating new documents or
/// editing existing documents in a DocumentList. Specifying an index
/// for a document in a DocumentList causes the form to be in edit mode,
/// otherwise it will create a new document.
class DocumentForm extends StatefulWidget {
  /// The DocumentList on which the forms acts.
  final DocumentList documentList;

  /// If supplied, the Document to edit. If null, a new Document
  /// will be created.
  final Document document;

  /// If supplied, will be used to decorate the form
  final BoxDecoration decoration;

  // If supplied, will be used to decorate fields in the form
  final BoxDecoration fieldDecoration;

  DocumentForm(this.documentList,
      {this.document, this.decoration, this.fieldDecoration});
  @override
  _DocumentFormState createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // A document to get updated by the form
  Document _document;

  @override
  void initState() {
    // create a new document if one was not supplied
    if (widget.document == null)
      _document = Document();
    else
      _document = widget.document;
    super.initState();
  }

  List<Widget> _buildFormFields(BuildContext context) {
    List<Widget> fields = [];

    // creat a form field for each support label
    widget.documentList.labels.keys.forEach((String label) {
      // Use the labels map to get initial values in the case
      // where the form is editing an existig document
      dynamic initialValue;
      if (widget.document != null) {
        initialValue = _document[widget.documentList.labels[label]];
      }

      // add to the array of input fields
      fields.add(
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: widget.fieldDecoration,
          child: TypedInputField(widget.documentList.labels[label],
              label: label,
              initialValue: initialValue, onSaved: (dynamic value) {
            // update the field with whatever data was in the input field
            // this will cause the Document to autosave
            _document[widget.documentList.labels[label]] = value;
          }),
          margin: EdgeInsets.all(10.0),
        ),
      );
    });

    fields.add(Container(
      padding: EdgeInsets.only(left: 100.0, right: 100.0),
      child: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            // this will caused onSaved to be called for each input field
            // which will cause the document to autosave
            formKey.currentState.save();
            // add a new form to the documentList
            if (widget.document == null) {
              widget.documentList.add(_document);
            }
            Navigator.pop(context);
          }),
    ));
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    IconData titleIconData = widget.document == null ? Icons.add : Icons.edit;
    return Scaffold(
      appBar: AppBar(
        title: Icon(titleIconData),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                formKey.currentState.save();
                if (widget.document == null) {
                  widget.documentList.add(_document);
                }
                Navigator.pop(context);
              }),
        ],
      ),
      body: Form(
        key: formKey,
        child: Container(
          decoration: widget.decoration,
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              children: _buildFormFields(context),
            ),
          ),
        ),
      ),
    );
  }
}

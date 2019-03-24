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
  Map<String, dynamic> _documentValues = Map<String, dynamic>();

  List<Widget> _buildFormFields(BuildContext context) {
    List<Widget> fields = [];
    // creat a form field for each support label
    widget.documentList.labels.keys.forEach((String label) {
      String fieldName = widget.documentList.labels[label];
      // Use the labels map to get initial values in the case
      // where the form is editing an existig document
      dynamic initialValue;
      if (widget.document != null) {
        initialValue = widget.document[fieldName];
      }
      FieldOptions fieldOptions;
      if (widget.documentList.fieldOptionsMap != null) {
        fieldOptions = widget.documentList.fieldOptionsMap[fieldName];
      }
      // add to the array of input fields
      fields.add(
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: widget.fieldDecoration,
          child: TypedInputField(fieldName,
              label: label,
              fieldOptions: fieldOptions,
              initialValue: initialValue, onSaved: (dynamic value) {
            _documentValues[widget.documentList.labels[label]] = value;
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
            _saveDocument(context);
          }),
    ));
    return fields;
  }

  void _saveDocument(BuildContext context) {
    formKey.currentState.save();
    if (widget.document == null) {
      Document doc = Document.fromMap(_documentValues,
          persistenceProvider: widget.documentList.persistenceProvider);
      widget.documentList.add(doc);
    } else {
      widget.document.updateValues(_documentValues);
    }
    Navigator.pop(context);
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
                _saveDocument(context);
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

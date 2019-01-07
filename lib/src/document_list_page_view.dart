import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';

class DocumentListPageView extends StatefulWidget {
  final DocumentList documentList;
  DocumentListPageView(this.documentList);
  _DocumentListPageViewState createState() => _DocumentListPageViewState();
}

class _DocumentListPageViewState extends State<DocumentListPageView> {
  DocumentList data;

  @override
  initState() {
    super.initState();
    data = widget.documentList;
  }

  @override
  Widget build(BuildContext context) {
    widget.documentList.addListener(() {
      setState(() {});
    });
    
    if (!widget.documentList.documentsLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return PageView.builder(
        itemCount: widget.documentList.length,
        itemBuilder: (BuildContext context, int i) {
          return DocumentPage(
            document: widget.documentList[i],
            labels: widget.documentList.labels,
          );
        });
  }
}

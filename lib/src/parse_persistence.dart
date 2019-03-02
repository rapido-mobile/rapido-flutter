import 'package:rapido/rapido.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'dart:async';

class ParsePersistence implements PersistenceProvider {
  @override
  deleteDocument(Document doc) {
    return null;
  }

  @override
  Future loadDocuments(DocumentList documentList,
      {Function onChangedListener}) {
    return null;
  }

  @override
  Future<Document> retrieveDocument(String docId) {
    return null;
  }

  @override
  Future<bool> saveDocument(Document doc) {
    ParseObject obj = ParseObject(doc.documentType, debug: true);
    for (String key in doc.keys) {
      if (!key.startsWith("_")) {
        obj.set(key, doc[key]);
      }
    }
    obj.create();
    return null;
  }
}

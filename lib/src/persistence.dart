import 'package:rapido/rapido.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

abstract class PersistenceBase {
  Future<bool> saveDocument(Document doc);

  Future<Document> retrieveDocument(String docId);

  Future<List<Document>> retrieveDocuments(String documentType);
}

class LocalFilePersistence implements PersistenceBase {
  Future<bool> saveDocument(Document doc) async {
       final file = await _localFile(doc["_id"]);
    // Write the file
    String mapString = json.encode(doc);
    file.writeAsString('$mapString');

    return true;
  }

  Future<Document> retrieveDocument(String docId) async {
    return null;
  }

  Future<List<Document>> retrieveDocuments(String documentType) async {
    return null;
  }
    Future<File> _localFile(String id) async {
    final path = await _localPath;
    return File('$path/$id.json');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    return path;
  }
}

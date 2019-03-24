import 'package:rapido/rapido.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

abstract class PersistenceProvider {
  Future<bool> saveDocument(Document doc);
  Future loadDocuments(DocumentList documentList, {Function onChangedListener});
  Future deleteDocument(Document doc);
}

class LocalFilePersistence implements PersistenceProvider {

  const LocalFilePersistence();
  
  Future<bool> saveDocument(Document doc) async {
    final file = await _localFile(doc["_id"]);
    // Write the file
    String mapString = json.encode(doc);
    file.writeAsString('$mapString');

    return true;
  }

  Future loadDocuments(DocumentList documentList,
      {Function onChangedListener}) async {
    // final List<Document> _documents = [];
    Directory appDir = await getApplicationDocumentsDirectory();

    appDir
        .listSync(recursive: true, followLinks: true)
        .forEach((FileSystemEntity f) {
      if (f.path.endsWith('.json')) {
        Document doc = _readDocumentFromFile(
            f, documentList.documentType, documentList.notifyListeners);
        if (doc != null) documentList.add(doc, saveOnAdd: false);
      }
    });
  }

  Document _readDocumentFromFile(
      FileSystemEntity f, String documentType, Function notifyListeners) {
    
    Map m = _loadMapFromFilePath(f);
    Document loadedDoc = Document.fromMap(m);
    if (loadedDoc["_docType"] == documentType) {
      loadedDoc.addListener(notifyListeners);
      return loadedDoc;
    }
    return null;
  }

  Map _loadMapFromFilePath(FileSystemEntity f) {
    String j = new File(f.path).readAsStringSync();

    if (j.length != 0) {
      Map newData = json.decode(j);
      newData.keys.forEach((dynamic key) {
        if (key == "latlong" && newData[key] != null) {
          // convert latlongs to the correct type
          newData[key] = Map<String, double>.from(newData[key]);
        }
      });
      return newData;
    }
    return null;
  }

  Future<File> _localFile(String id) async {
    final path = await _localPath;
    return File('$path/$id.json');
  }

  Future deleteDocument(Document doc) async {
    final file = await _localFile(doc.id);
    file.delete();
    return null;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    return path;
  }
}
import 'dart:collection';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'persistence.dart';

/// A Document is a persisted Map of type <String, dynamic>.
/// It is used by DocumentList amd all related UI widgets.
class Document extends MapBase<String, dynamic> with ChangeNotifier {
  Map<String, dynamic> _map = {};

  final bool saveOnline;
  final bool saveLocally;

  /// The Documents type, typically used to organize documents
  /// typically used to organize documents, for example in a DocumentList
  String get documentType => _map["_docType"];
  set documentType(String v) => _map["docType"] = v;

  /// The documents unique id. Typically used to manage persistence,
  /// such as in Document.save()
  String get id => _map["_id"];
  set id(String v) => _map["_id"] = v;

  /// Create a Document. Optionally include a map of type
  /// Map<String, dynamic> to initially populate the Document with data.
  ///Optionally save documents on a remote server
  Document({
    Map<String, dynamic> initialValues,
    this.saveOnline = false,
    this.saveLocally = true,
  }) {
    // initial values if provided
    if (initialValues != null) {
      initialValues.keys.forEach((String key) {
        _map[key] = initialValues[key];
      });
    }
    // if there is no id yet, create one
    if (_map["_id"] == null) {
      _map["_id"] = randomFileSafeId(24);
    }
  }

  dynamic operator [](Object fieldName) => _map[fieldName];

  void operator []=(String fieldName, dynamic value) {
    _map[fieldName] = value;
    save();
  }

  void clear() {
    _map.clear();
    notifyListeners();
  }

  void remove(Object key) {
    _map.remove(key);
    notifyListeners();
  }

  List<String> get keys {
    return _map.keys.toList();
  }

  Future<bool> save() async {
    bool result = await LocalFilePersistence().saveDocument(this);
    notifyListeners();
    return result;
  }



  void loadFromFilePath(FileSystemEntity f) {
    String j = new File(f.path).readAsStringSync();

    if (j.length != 0) {
      Map newData = json.decode(j);
      newData.keys.forEach((dynamic key) {
        if (key == "latlong" && newData[key] != null) {
          // convert latlongs to the correct type
          newData[key] = Map<String, double>.from(newData[key]);
        }
        _map[key] = newData[key];
      });
      _map["_id"] = newData["_id"];
    } else {
      //TODO: Debug this
      // This only seems to occur during testing, and
      // seems to be a race condition I have not tracked down
      // and it's not clear why the _loadLocalData function is
      // even called
      // print("Warning: ${f.path} file was empty.");
    }
    notifyListeners();
  }

  static String randomFileSafeId(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      List<int> illegalChars = [34, 39, 44, 96];
      int randChar = rand.nextInt(33) + 89;
      while (illegalChars.contains(randChar)) {
        randChar = rand.nextInt(33) + 89;
      }
      return randChar;
    });

    return new String.fromCharCodes(codeUnits);
  }
}

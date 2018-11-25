import 'dart:collection';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

/// A Document is a persisted Map of type <String, dynamic>.
/// It is used by DocumentList amd all related UI widgets.
class Document extends MapBase<String, dynamic> {
  Map<String, dynamic> _map = {};
  String documentType;
  String id;

  /// Create a Document. Optionally include a map of type
  /// Map<String, dynamic> to initially populate the Document with data.
  Document([Map<String, dynamic> initialValues, this.id]) {
    // initial values if provided
    if (initialValues != null) {
      initialValues.keys.forEach((String key) {
        _map[key] = initialValues[key];
      });
      // if an id was provided in the initial values, use that
      if(_map["_id"] != null) {
        id = _map["_id"];
      }
    }
    // if there is no id yet, create one
    if(id == null){
      id = randomFileSafeId(24);
      _map["_id"] = id;
    }
  }

  dynamic operator [](Object fieldName) => _map[fieldName];
  void operator []=(String fieldName, dynamic value) {
    _map[fieldName] = value;
   // _writeLocal();
  }

  void clear() {
    _map.clear();
  }

  void remove(Object key) {
    _map.remove(key);
  }

  List<String> get keys {
    return _map.keys.toList();
  }

  Future<File> save() async {
    final file = await _localFile(id);
    // Write the file
    String mapString = json.encode(_map);
    return file.writeAsString('$mapString');
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

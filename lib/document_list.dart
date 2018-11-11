library a2s_widgets;

import 'dart:collection';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

class DocumentList extends ListBase<Map<String, dynamic>> {
  final String documentType;
  Function onLoadComplete;
  Map<String, String> _labels;
  List<Map<String, dynamic>> _documents;
  Function onChanged;

  set length(int newLength) { _documents.length = newLength; }
  int get length => _documents.length;
  Map<String, dynamic> operator [](int index) => _documents[index];
  void operator []=(int index, Map<String, dynamic> value) { _updateDocment(index, value);}//documents[index] = value; }

  DocumentList(this.documentType,
      {this.onLoadComplete,
      Map<String, String> labels,
      this.onChanged}) {
    _labels = labels;
    _documents = [];
    _loadLocalData();
  }

  set labels(Map<String, String> labels) {
    _labels = labels;
  }

  Map<String, String> get labels {
    if (_labels == null) {
      if (_documents.length < 1) {
        return null;
      }
      Map<String, dynamic> map = _documents[0];
      Map<String, String> tempLabels = Map<String, String>();
      map.keys.forEach((String k) {
        if (!k.startsWith("_")) {
          tempLabels[k] = k;
        }
      });
      _labels = tempLabels;
    }
    return _labels;
  }

  void _notifyListener() {
    if (onChanged != null) {
      onChanged(this);
    }
  }

  void _loadLocalData() async {
    getApplicationDocumentsDirectory().then((Directory appDir) {
      appDir
          .listSync(recursive: true, followLinks: true)
          .forEach((FileSystemEntity f) {
        if (f.path.endsWith('.json')) {
          String j = new File(f.path).readAsStringSync();
          Map newData = json.decode(j);
          if (newData["_docType"].toString() == documentType) {
            _documents.add(newData);
          }
        }
      });
      if (onLoadComplete != null) onLoadComplete(this);
      _notifyListener();
    });
  }

  void _updateDocment(int index, Map<String, dynamic> map) {
    map.keys.forEach((String key){
      _documents[index][key] = map[key];
    });
    _documents[index]["_time_stamp"] = new DateTime.now().millisecondsSinceEpoch.toInt();
  
    _writeMapLocal(_documents[index]);
    _notifyListener();
  }
  @override
  void add(Map<String, dynamic> map) {
    map["_docType"] = documentType;
    map["_id"] = randomFileSafeId(24);
    map["_time_stamp"] = new DateTime.now().millisecondsSinceEpoch.toInt();
    _documents.add(map);
    _writeMapLocal(map);
    _notifyListener();
  }

  @override
  bool remove(Object value) {
    Map<String, dynamic> map = value;
    for(int i = 0 ; i < _documents.length ; i++) {
        if(map == _documents[i]){
          removeAtIndex(i);
          return true;
        }
    }
    return false;
  }

  void removeAtIndex(int index) {
    _deleteMapLocal(_documents[index]["_id"]);
    _documents.removeAt(index);
    _notifyListener();
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

  void _deleteMapLocal(String id) async {
    final file = await _localFile(id);
    file.delete();
  }

  Future<File> _writeMapLocal(Map<String, dynamic> map) async {
    final file = await _localFile(map["_id"]);
    // Write the file
    String mapString = json.encode(map);
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
}

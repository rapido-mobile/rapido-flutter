library a2s_widgets;

import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:scoped_model/scoped_model.dart';

class PersistedModel extends Model {
  final String documentType;
  Function onLoadComplete;
  Map<String, String> _labels;

  List<Map<String, dynamic>> data;

  PersistedModel(this.documentType,
      {this.onLoadComplete, Map<String, String> labels}) {
    _labels = labels;
    data = [];
    _loadLocalData();
  }

  set labels(Map<String, String> labels) {
    _labels = labels;
  }

  Map<String, String> get labels {
    if (_labels == null) {
      if (data.length < 1) {
        return null;
      }
      Map<String, dynamic> map = data[0];
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

  void _loadLocalData() async {
    getApplicationDocumentsDirectory().then((Directory appDir) {
      appDir
          .listSync(recursive: true, followLinks: true)
          .forEach((FileSystemEntity f) {
        if (f.path.endsWith('.json')) {
          String j = new File(f.path).readAsStringSync();
          Map newData = json.decode(j);
          if (newData["_docType"].toString() == documentType) {
            data.add(newData);
          }
        }
      });
      notifyListeners();
      if (onLoadComplete != null) onLoadComplete(this);
    });
  }

  void add(Map<String, dynamic> map) {
    map["_docType"] = documentType;
    map["_id"] = randomFileSafeId(24);
    map["_time_stamp"] = new DateTime.now().millisecondsSinceEpoch.toInt();
    data.add(map);
    print("Data added, notifying listeners");
    notifyListeners();
    print("Listeners notified, writing file");
    _writeMapLocal(map);
    print("file written");
  }

  void delete(int index) {
    _deleteMapLocal(data[index]["_id"]);
    data.removeAt(index);
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

  void _deleteMapLocal(String id) async {
    final file = await _localFile(id);

    print("Deleting " + id);
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

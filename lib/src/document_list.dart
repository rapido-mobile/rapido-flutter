library rapido;

import 'dart:collection';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:rapido/documents.dart';

/// A list Documents. DocumentList automatically persists changes
/// to the list through, adding, removing, and updating documents that it
/// contains. The document_widgets library can render useful UI elements
/// for a DocumentList.
class DocumentList extends ListBase<Document> {
  /// A unique string identifying the documents organized by the list.
  final String documentType;

  /// A callback function that fires after a DocumentList is finished loading
  /// persisted data. It passes a reference to itself,
  /// onLoadComplete: (DocumentList documentList) {/* do something */}
  Function onLoadComplete;
  Map<String, String> _labels;
  List<Document> _documents;

  /// A callback function that is called for any changes in the DocumentList,
  /// such as adding, removing, or updating documents. It passes a reference
  /// to itself, onChanged: (DocumentList documentList) {/* do something */}
  Function onChanged;

  set length(int newLength) {
    _documents.length = newLength;
  }

  int get length => _documents.length;

  Document operator [](int index) => _documents[index];

  void operator []=(int index, Document value) {
    Document oldDoc = _documents[index];
    _documents[index] = value;
    _documents[index]["_time_stamp"] =
        new DateTime.now().millisecondsSinceEpoch.toInt();
    _documents[index]["_docType"] = documentType;

    _documents[index].save();
    _deleteMapLocal(oldDoc["_id"]);
    _notifyListener();
  }

  /// The documentType parameter should be unique.
  DocumentList(this.documentType,
      {this.onLoadComplete, Map<String, String> labels, this.onChanged}) {
    _labels = labels;
    _documents = [];
    _loadLocalData();
  }

  set labels(Map<String, String> labels) {
    _labels = labels;
  }

  /// The labels to use in UI elements. If the labels property is not set, the
  /// DocumentList will simply return any key not starting with "_".
  /// Returns null if there is no data and no labels provided.
  Map<String, String> get labels {
    if (_labels == null) {
      if (_documents.length < 1) {
        return null;
      }
      Document doc = _documents[0];
      Map<String, String> tempLabels = Map<String, String>();
      doc.keys.forEach((String k) {
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

  @override
  void add(Document doc) {
    doc["_docType"] = documentType;
    doc["_time_stamp"] = new DateTime.now().millisecondsSinceEpoch.toInt();
    _documents.add(doc);
    doc.onChanged = (Document doc) {
      _notifyListener();
    };
    doc.save();
    _notifyListener();
  }

  @override
  addAll(Iterable<Document> list) {
    list.forEach((Document doc) {
      add(doc);
      doc.onChanged = _docChanged;
    });
  }

  @override
  bool remove(Object value) {
    Map<String, dynamic> map = value;
    for (int i = 0; i < _documents.length; i++) {
      if (map == _documents[i]) {
        removeAt(i);
        return true;
      }
    }
    return false;
  }

  @override
  clear() {
    _documents.forEach((Document doc) {
      _deleteMapLocal(doc["_id"]);
    });
    super.clear();
  }

  @override
  Document removeAt(int index) {
    Document doc = _documents[index];
    _deleteMapLocal(_documents[index]["_id"]);
    _documents.removeAt(index);
    _notifyListener();
    return doc;
  }

  @override
  void sort([int compare(Document a, Document b)]) {
    _documents.sort(compare);
    _notifyListener();
  }

  /// Sorts by the field specified in the required parameter fieldName.
  /// Optionally specify sortOrder to sort in ascending or descending order.
  /// Defaults to ascending order.
  void sortByField(String fieldName,
      {SortOrder sortOrder: SortOrder.ascending}) {
    if (sortOrder == SortOrder.ascending) {
      sort((a, b) {
        //handle null fields
        if (a[fieldName] == null && b[fieldName] == null) return 0;
        if (a[fieldName] == null && b[fieldName] != null) return -1;
        if (a[fieldName] != null && b[fieldName] == null) return 1;
        return a[fieldName].compareTo(b[fieldName]);
      });
    } else {
      sort((a, b) {
        if (a[fieldName] == null && b[fieldName] == null) return 0;
        if (a[fieldName] == null && b[fieldName] != null) return 1;
        if (a[fieldName] != null && b[fieldName] == null) return -1;
        return b[fieldName].compareTo(a[fieldName]);
      });
    }
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

  // Current persistence implementation is below. It simply persists documents
  // as json files on disk. Depending on requirements and usage this can/will
  // be changed to a more scalable method. Such changes should be invisible
  // to existing users.
  void _deleteMapLocal(String id) async {
    final file = await _localFile(id);
    file.delete();
  }

  void _docChanged(Document doc) {
    _notifyListener();
  }

  void _loadLocalData() async {
    getApplicationDocumentsDirectory().then((Directory appDir) {
      appDir
          .listSync(recursive: true, followLinks: true)
          .forEach((FileSystemEntity f) {
        if (f.path.endsWith('.json')) {
          Document loadedDoc = Document();
          loadedDoc.loadFromFilePath(f);
          if (loadedDoc["_docType"] == documentType) {
            _documents.add(loadedDoc);
            loadedDoc.onChanged = _docChanged;
          }
        }
      });
      if (onLoadComplete != null) onLoadComplete(this);
      _notifyListener();
    });
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

enum SortOrder { ascending, descending }
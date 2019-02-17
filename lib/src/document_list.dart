library rapido;

import 'dart:collection';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:rapido/rapido.dart';
import 'package:flutter/foundation.dart';

/// A list Documents. DocumentList automatically persists changes
/// to the list through, adding, removing, and updating documents that it
/// contains. The document_widgets library can render useful UI elements
/// for a DocumentList.
class DocumentList extends ListBase<Document> with ChangeNotifier {
  /// A unique string identifying the documents organized by the list.
  final String documentType;

  /// A callback function that fires after a DocumentList is finished loading
  /// persisted data. It passes a reference to itself,
  /// onLoadComplete: (DocumentList documentList) {/* do something */}
  Function onLoadComplete;

  /// True when there are no more documents to load
  /// False when documents are still loading
  bool documentsLoaded = false;

  Map<String, String> _labels;
  List<Document> _documents;

  /// FieldOptions permit specifying how to render a field in different
  /// circumstances, most commonly in a DocumentForm. fieldOptionsMap is
  /// map of field names to objects that are subclass of FieldOptions.
  Map<String, FieldOptions> fieldOptionsMap;

  /// Optional list of Documents to initialize the DocumentList.
  /// Whenever the DocumentList first initializes, if there are no
  /// existing Documents already persisted, the DocumentList will
  /// initialize itself with this list of Documents. If there are
  /// are one for more Documents already persisted, this property
  /// will be ignored.
  final List<Document> initialDocuments;

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
    notifyListeners();
  }

  /// The documentType parameter should be unique.
  DocumentList(this.documentType,
      {this.onLoadComplete,
      this.initialDocuments,
      Map<String, String> labels,
      this.fieldOptionsMap}) {
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

  @override
  void add(Document doc) {
    doc["_docType"] = documentType;
    doc["_time_stamp"] = new DateTime.now().millisecondsSinceEpoch.toInt();
    _documents.add(doc);
    doc.addListener(() {
      notifyListeners();
    });
    doc.save();
    notifyListeners();
  }

  @override
  addAll(Iterable<Document> list) {
    list.forEach((Document doc) {
      add(doc);
      doc.addListener(() {
        notifyListeners();
      });
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
    notifyListeners();
    return doc;
  }

  @override
  void sort([int compare(Document a, Document b)]) {
    _documents.sort(compare);
    notifyListeners();
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

  // Current persistence implementation is below. It simply persists documents
  // as json files on disk. Depending on requirements and usage this can/will
  // be changed to a more scalable method. Such changes should be invisible
  // to existing users.
  void _deleteMapLocal(String id) async {
    final file = await _localFile(id);
    file.delete();
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
            loadedDoc.addListener(() {
              notifyListeners();
            });
          }
        }
      });
      if (_documents.length == 0 && initialDocuments != null) {
        addAll(this.initialDocuments);
        _signalLoadComplete();
      } else {
        _signalLoadComplete();
      }
    });
  }

  void _signalLoadComplete() {
    documentsLoaded = true;
    if (onLoadComplete != null) onLoadComplete(this);
    notifyListeners();
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

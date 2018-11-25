import 'dart:collection';

/// A Document is a persisted Map of type <String, dynamic>.
/// It is used by DocumentList amd all related UI widgets.
class Document extends MapBase<String, dynamic> {
  Map<String, dynamic> _map = {};

  /// Create a Document. Optionally include a map of type
  /// Map<String, dynamic> to initially populate the Document with data.
  Document([Map<String, dynamic> initialValues]) {
    if (initialValues != null) {
      initialValues.keys.forEach((String key) {
        _map[key] = initialValues[key];
      });
    }
  }

  dynamic operator [](Object fieldName) => _map[fieldName];
  void operator []=(String fieldName, dynamic value) {
    _map[fieldName] = value;
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
}

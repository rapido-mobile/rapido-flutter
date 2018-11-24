import 'dart:collection';

class Document extends MapBase<String, dynamic> {
  Map<String, dynamic> _map = {};

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

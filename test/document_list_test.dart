import 'package:test/test.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:rapido/document_list.dart';

void main() {
  test('creates a PersistedModel', () {
    DocumentList persistedModel = DocumentList("testDocumentType");
    persistedModel
        .add({"count": 0, "rating": 5, "price": 1.5, "name": "Pickle Rick"});
    persistedModel
        .add({"count": 1, "rating": 4, "price": 1.5, "name": "Rick Sanchez"});
    expect(persistedModel.length, 2);
  });
  test('reads existing PersistedModel from disk', () {
    DocumentList("testDocumentType", onLoadComplete: (DocumentList model) {
      expect(model.length, 2);
      String name = model[0]["name"];
      expect(name.contains("Rick"), true);
      name = model[1]["name"];
      expect(name.contains("Rick"), true);
      expect(model[0]["price"], 1.5);
    });
  });
  test('tests that any() works', () {
    DocumentList("testDocumentType", onLoadComplete: (DocumentList model) {
      bool c = model.any((Map<String, dynamic> map) {
        return map.containsValue("Rick Sanchez");
      });
      expect(c, true);
    });
  });

  test('foreach()', () {
    DocumentList("addAllTest", onLoadComplete: (DocumentList model) {
      model.forEach((Map<String, dynamic> map) {
        expect(map["name"].toString().contains("Rick"), true);
      });
    });
  });

  test('sort()', () {
    DocumentList list = DocumentList("sortTest");
    list.add({"a": 3});
    list.add({"a": 2});
    list.add({"a": 1});
    list.sort((a, b) => a["a"] - b["a"]);
    expect(list[0]["a"], 1);
    expect(list[1]["a"], 2);
    expect(list[2]["a"], 3);
  });

  test('test maps get updated and timestamp is changed', () {
    DocumentList("testDocumentType", onLoadComplete: (DocumentList model) {
      Map<String, dynamic> updatedMap = {
        "count": 1,
        "rating": 1,
        "price": 2.5,
        "name": "Edited Name"
      };
      int oldTimeStamp = model[0]["_time_stamp"];
      model[0] = updatedMap;
      expect(model[0]["count"], 1);
      expect(model[0]["rating"], 1);
      expect(model[0]["price"], 2.5);
      expect(model[0]["name"], "Edited Name");
      expect(model[0]["_time_stamp"], greaterThan(oldTimeStamp));
    });
  });

  test('checks that updates persist on disk', () {
    sleep(Duration(seconds: 1));
    DocumentList("testDocumentType", onLoadComplete: (DocumentList model) {
      bool testMapFound = false;
      model.forEach((Map<String, dynamic> map) {
        if (map["name"] == "Edited Name") {
          expect(map["count"], 1);
          expect(map["rating"], 1);
          expect(map["price"], 2.5);
          testMapFound = true;
        }
      });
      expect(testMapFound, true);
    });
  });

  test('deletes maps from the model', () {
    DocumentList("testDocumentType", onLoadComplete: (DocumentList model) {
      model.removeAt(0);
      DocumentList("testDocumentType", onLoadComplete: (DocumentList model) {
        expect(model.length, 1);
      });
    });
  });

  test('unit test for randomFileSafeId', () {
    String rnd = DocumentList.randomFileSafeId(8);
    expect(rnd.length, 8);
  });

  test('set ui labels in constructor', () {
    DocumentList model = DocumentList("a", labels: {"a": "A", "b": "B"});
    expect(model.labels["a"], "A");
    expect(model.labels["b"], "B");
  });
  test('removeAt() and first', () {
    DocumentList list = DocumentList("removeAtTeest");
    for (int i = 0; i < 10; i++) {
      list.add({"a": i});
    }
    list.removeAt(0);
    expect(list.first["a"], 1);
  });

  test('removeAt() survives persistence', () {
    DocumentList("removeAtTeest", onLoadComplete: (DocumentList list) {
      expect(list.length, 9);
    });
  });

  test('infer ui labels', () {
    DocumentList model = DocumentList("abc");
    model.add({"a": "A", "b": "B", "c": "C"});
    expect(model.labels["a"], "a");
    expect(model.labels["b"], "b");
    expect(model.labels["c"], "c");
    expect(model.labels.length, 3);
  });

  test('unset labels should return null', () {
    DocumentList model = DocumentList("def");
    expect(model.labels, null);
  });

  test('addAll', () {
    List<Map<String, dynamic>> all = [
      {"a": 1},
      {"a": 2}
    ];
    DocumentList dl = DocumentList("addAllTest");
    dl.addAll(all);
    expect(dl.length, 2);
  });

  test('checks that using addAll persists data', () {
    DocumentList("addAllTest", onLoadComplete: (DocumentList model) {
      expect(model.length, 2);
    });
  });

  test('clear()', () {
    DocumentList("addAllTest", onLoadComplete: (DocumentList model) {
      model.clear();
      expect(model.length, 0);
    });
  });

  test('test that clear() works across persistence', () {
    DocumentList("addAllTest", onLoadComplete: (DocumentList model) {
      expect(model.length, 0);
    });
  });

  test('remove object', (){
    DocumentList list = DocumentList("removeTest");
    Map<String, dynamic> testObj = {"a":1};
    list.add(testObj);
    expect(list.length, 1);
    expect(list.remove(testObj), true);
    expect(list.length, 0);
  });
  test('sortByField', () {
    DocumentList list = DocumentList("sortByField");
    for (int i = 0; i < 10; i++) {
      list.add({"a": i});
    }
    list.sortByField("a", sortOrder:SortOrder.descending);
    expect(list[0]["a"], 9);
    expect(list[9]["a"], 0);
 
    list.sortByField("a", sortOrder:SortOrder.ascending);
    expect(list[0]["a"], 0);
    expect(list[9]["a"], 9);

  });

  setUpAll(() async {
    // Create a temporary directory to work with
    final directory = await Directory.systemTemp.createTemp();

    // Mock out the MethodChannel for the path_provider plugin
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      // If we're getting the apps documents directory, return the path to the
      // temp directory on our test environment instead.
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return directory.path;
      }
      return null;
    });
  });
}

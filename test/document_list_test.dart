import 'package:test/test.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:rapido/rapido.dart';

void main() {
  test('creates a DocumentList', () {
    DocumentList documentList = DocumentList("testDocumentType");
    documentList.add(Document(initialValues: {
      "count": 0,
      "rating": 5,
      "price": 1.5,
      "name": "Pickle Rick"
    }));
    documentList.add(Document(initialValues: {
      "count": 1,
      "rating": 4,
      "price": 1.5,
      "name": "Rick Sanchez"
    }));
    expect(documentList.length, 2);
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

  test('onChanged works', () {
    DocumentList list = DocumentList("onchange");
    list.addListener(() {
      expect(list.length, 1);
    });
    list.add(Document(initialValues: {"a": 1}));
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

  test('set labels', () {
    DocumentList list = DocumentList("onchange");
    list.labels = {"A": "a"};
    list.add(Document(initialValues: {"a": 1}));
    expect(list.labels.length, 1);
    expect(list.labels.containsKey("A"), true);
  });
  test('sort()', () {
    DocumentList list = DocumentList("sortTest");
    list.add(Document(initialValues: {"a": 3}));
    list.add(Document(initialValues: {"a": 2}));
    list.add(Document(initialValues: {"a": 1}));
    list.sort((a, b) => a["a"] - b["a"]);
    expect(list[0]["a"], 1);
    expect(list[1]["a"], 2);
    expect(list[2]["a"], 3);
  });

  test('test []= operator, document is completely replaced', () {
    DocumentList("testDocumentType",
        onLoadComplete: (DocumentList documentList) {
      Document updatedDoc = Document(
          initialValues: {"count": 1, "price": 2.5, "name": "Edited Name"});
      int oldTimeStamp = documentList[0]["_time_stamp"];
      String oldId = documentList[0]["_id"];
      documentList[0] = updatedDoc;
      expect(documentList[0]["count"], 1);
      expect(documentList[0]["rating"], null);
      expect(documentList[0]["price"], 2.5);
      expect(documentList[0]["name"], "Edited Name");
      expect(documentList[0]["_time_stamp"], greaterThan(oldTimeStamp));
      expect(oldId == documentList[0]["_id"], false);
    });
  });

  test('checks that operator []=  persist on disk', () {
    DocumentList("testDocumentType", onLoadComplete: (DocumentList dl) {
      bool testMapFound = false;
      dl.forEach((Document doc) {
        if (doc["name"] == "Edited Name") {
          expect(doc["count"], 1);
          expect(doc["rating"], null);
          expect(doc["price"], 2.5);
          testMapFound = true;
        }
      });
      expect(testMapFound, true);
    });
  });

  test('tests removeAt removes documents and returns the removed doc',
      () async {
    DocumentList("testDocumentType",
        onLoadComplete: (DocumentList documentList) {
      Document zeroDoc = documentList[0];
      Document removedDoc = documentList.removeAt(0);
      expect(zeroDoc == removedDoc, true);
      DocumentList("testDocumentType", onLoadComplete: (DocumentList dl) {
        dl.forEach((Document doc) {
          expect(doc["_id"] != zeroDoc["_id"], true);
        });
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
      list.add(Document(initialValues: {"a": i}));
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
    model.add(Document(initialValues: {"a": "A", "b": "B", "c": "C"}));
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
    List<Document> all = [
      Document(initialValues: {"a": 1}),
      Document(initialValues: {"a": 2})
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
    DocumentList("addAllTest", onLoadComplete: (DocumentList model) async {
      model.clear();
      expect(model.length, 0);
    });
  });

  test('test that clear() works across persistence', () {
    DocumentList("addAllTest", onLoadComplete: (DocumentList model) async {
      expect(model.length, 0);
    });
  });

  test('remove object', () {
    DocumentList list = DocumentList("removeTest");
    Document testObj = Document(initialValues: {"a": 1});
    list.add(testObj);
    expect(list.length, 1);
    expect(list.remove(testObj), true);
    expect(list.length, 0);
  });
  test('sortByField', () {
    // TODO: add tests for other field types (date)
    DocumentList list = DocumentList("sortByField");
    List<String> strings = [
      "abcd",
      "bcde",
      "cdef",
      "defg",
      "efgh",
      "fghi",
      "ghij",
      "hijk",
      "ijkl",
      "jklm",
    ];
    for (int i = 0; i < 10; i++) {
      list.add(Document(initialValues: {"a": i, "b": strings[i]}));
    }
    list.sortByField("a", sortOrder: SortOrder.descending);
    expect(list[0]["a"], 9);
    expect(list[9]["a"], 0);

    list.sortByField("a", sortOrder: SortOrder.ascending);
    expect(list[0]["a"], 0);
    expect(list[9]["a"], 9);

    list.sortByField("b", sortOrder: SortOrder.descending);
    expect(list[0]["a"], 9);
    expect(list[2]["a"], 7);
    expect(list[4]["a"], 5);
    expect(list[6]["a"], 3);
    expect(list[8]["a"], 1);
    expect(list[9]["a"], 0);

    list.sortByField("b", sortOrder: SortOrder.ascending);
    expect(list[0]["a"], 0);
    expect(list[9]["a"], 9);
  });

  test('sortByField works when a value is null', () {
    DocumentList brokenList = DocumentList("broken");
    brokenList.add(Document(initialValues: {"a": 1}));
    brokenList.add(Document(initialValues: {"b": 1}));
    brokenList.sortByField("a", sortOrder: SortOrder.ascending);
    expect(brokenList[0]["b"] == 1, true);
    expect(brokenList[1]["a"] == 1, true);
    brokenList.sortByField("a", sortOrder: SortOrder.descending);
    expect(brokenList[0]["a"] == 1, true);
    expect(brokenList[1]["b"] == 1, true);
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

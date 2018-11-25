import 'package:test/test.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:rapido/documents.dart';

void main() {
  test('creates a PersistedModel', () {
    DocumentList persistedModel = DocumentList("testDocumentType");
    persistedModel.add(Document({
      "count": 0,
      "rating": 5,
      "price": 1.5,
      "name": "Pickle Rick"
    }));
    persistedModel
        .add(Document({"count": 1, "rating": 4, "price": 1.5, "name": "Rick Sanchez"}));
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

  test('onChanged works', () {
    DocumentList list = DocumentList("onchange");
    // TODO: why is onChanged called twice?
    list.onChanged = (DocumentList l) {
      expect(l.length, 1);
    };
    list.add(Document({"a": 1}));
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
    list.add(Document({"a": 1}));
    expect(list.labels.length, 1);
    expect(list.labels.containsKey("A"), true);
  });
  test('sort()', () {
    DocumentList list = DocumentList("sortTest");
    list.add(Document({"a": 3}));
    list.add(Document({"a": 2}));
    list.add(Document({"a": 1}));
    list.sort((a, b) => a["a"] - b["a"]);
    expect(list[0]["a"], 1);
    expect(list[1]["a"], 2);
    expect(list[2]["a"], 3);
  });

  test('test maps get updated and timestamp is changed', () {
    DocumentList("testDocumentType", onLoadComplete: (DocumentList documentList) {
      Document updatedDoc = Document({
        "count": 1,
        "rating": 1,
        "price": 2.5,
        "name": "Edited Name"
      });
      int oldTimeStamp = documentList[0]["_time_stamp"];
      documentList[0] = updatedDoc;
      expect(documentList[0]["count"], 1);
      expect(documentList[0]["rating"], 1);
      expect(documentList[0]["price"], 2.5);
      expect(documentList[0]["name"], "Edited Name");
      expect(documentList[0]["_time_stamp"], greaterThan(oldTimeStamp));
    });
  });

  test('checks that updates persist on disk', () {
    sleep(Duration(seconds: 1));
    DocumentList("testDocumentType", onLoadComplete: (DocumentList model) {
      bool testMapFound = false;
      model.forEach((Document doc) {
        if (doc["name"] == "Edited Name") {
          expect(doc["count"], 1);
          expect(doc["rating"], 1);
          expect(doc["price"], 2.5);
          testMapFound = true;
        }
      });
      expect(testMapFound, true);
    });
  });

  test('deletes documents from the list', () {
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
      list.add(Document({"a": i}));
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
    model.add(Document({"a": "A", "b": "B", "c": "C"}));
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
      Document({"a": 1}),
      Document({"a": 2})
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

  test('remove object', () {
    DocumentList list = DocumentList("removeTest");
    Document testObj = Document({"a": 1});
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
      list.add(Document({"a": i, "b": strings[i]}));
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

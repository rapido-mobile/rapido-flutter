import 'package:test/test.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:a2s_widgets/persisted_model.dart';

void main() {
  test('creates a PersistedModel', () {
    PersistedModel persistedModel = PersistedModel("testDocumentType");
    persistedModel
        .add({"count": 0, "rating": 5, "price": 1.5, "name": "Pickle Rick"});
    persistedModel
        .add({"count": 1, "rating": 4, "price": 1.5, "name": "Rick Sanchez"});
    expect(persistedModel.data.length, 2);
  });
  test('reads existing PersistedModel from disk', () {
    PersistedModel("testDocumentType", onLoadComplete: (PersistedModel model) {
      expect(model.data.length, 2);
      String name = model.data[0]["name"];
      expect(name.contains("Rick"), true);
      name = model.data[1]["name"];
      expect(name.contains("Rick"), true);
      expect(model.data[0]["price"], 1.5);
    });
  });
  test('deletes maps from the model', () {
    PersistedModel("testDocumentType", onLoadComplete: (PersistedModel model) {
      model.delete(0);
      PersistedModel("testDocumentType",
          onLoadComplete: (PersistedModel model) {
        expect(model.data.length, 1);
      });
    });
  });

  test('unit test for randomFileSafeId', () {
    String rnd = PersistedModel.randomFileSafeId(8);
    expect(rnd.length, 8);
  });

  test('set ui labels in constructor', () {
    PersistedModel model = PersistedModel("a", labels: {"a": "A", "b": "B"});
    expect(model.labels["a"], "A");
    expect(model.labels["b"], "B");
  });

  test('infer ui labels', () {
    PersistedModel model = PersistedModel("abc");
    model.add({"a": "A", "b": "B", "c": "C"});
    expect(model.labels["a"], "a");
    expect(model.labels["b"], "b");
    expect(model.labels["c"], "c");
    expect(model.labels.length, 3);
  });

  test('unset labels should return null', () {
    PersistedModel model = PersistedModel("def");
    expect(model.labels, null);
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

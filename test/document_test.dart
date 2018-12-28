import 'package:test/test.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:rapido/rapido.dart';

void main() {
  String newName = "xxx";
  test('Setup DocumentList', () {
    DocumentList documentList = DocumentList("operator test type");
    documentList.add(Document(initialValues: {
      "count": 0,
      "rating": 5,
      "price": 1.5,
      "name": "NAME"
    }));
  });

  test('Document.[]= operator', () {
    DocumentList("operator test type", onLoadComplete: (DocumentList dl) {
      Document doc = dl[0];
      doc["name"] = newName;
      expect(dl[0]["name"] == newName, true);
    });
  });

  test('Document.[]= operator survives persistence', () {
    DocumentList("operator test type", onLoadComplete: (DocumentList dl) {
      expect(dl[0]["name"] == newName, true);
    });
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

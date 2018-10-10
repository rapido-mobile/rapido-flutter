import 'package:test/test.dart';

import 'dart:io';
import 'package:flutter/services.dart';

import 'package:a2s_widgets/persisted_model.dart';

void main() {
  test('creates a PersistedModel', () {
    PersistedModel persistedModel = PersistedModel("testDocumentType");
    persistedModel
        .add({"count": 0, "rating": 5, "price": "0.5", "name": "Pickle Rick"});
    persistedModel
        .add({"count": 1, "rating": 4, "price": "1.5", "name": "Rick Sanchez"});
    expect(persistedModel.data.length, 2);
  });
  test('reads existing PersistedModel from disk', () {
    PersistedModel("testDocumentType", 
    onLoadComplete: (List<Map<String,dynamic>> data) {
      expect(data.length,2);
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


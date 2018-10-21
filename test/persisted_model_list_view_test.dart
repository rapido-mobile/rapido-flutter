import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:a2s_widgets/persisted_model_list_view.dart';
import 'package:a2s_widgets/persisted_model.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() {
  testWidgets('Can display string as title', (WidgetTester tester) async {
    PersistedModel testModel = PersistedModel("testDocumentType");
    for (int i = 0; i < 10; i++) {
      testModel.add({ "field B": "${i.toString()}"});
    }
    await tester.pumpWidget(
      MaterialApp (
        home: Scaffold(
        body: PersistedModelListView(
            testModel,
            titleKeys: ["field B"],
          ),
        ),
      ),
    );
    expect(find.text("2"),findsOneWidget );
    expect(find.text("0"),findsOneWidget );
    expect(find.text("aaa"), findsNothing);
  }

  );

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

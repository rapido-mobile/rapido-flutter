import 'package:flutter_test/flutter_test.dart' as widgetTest;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:rapido/rapido.dart';
import "package:test/test.dart";

void main() {
  widgetTest.testWidgets('Can display fields as title and subtitle',
      (widgetTest.WidgetTester tester) async {
    DocumentList testModel = DocumentList("testDocumentType");
    for (int i = 0; i < 10; i++) {
      if (i == 1) {
        testModel.add(Document(initialValues: {
          "field B": "${i.toString()}",
          "field C": "subtitle"
        }));
      } else {
        testModel.add(Document(initialValues: {"field B": "${i.toString()}"}));
      }
    }
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DocumentListView(
            testModel,
            titleKeys: ["field B", "field A"],
            subtitleKey: "field C",
          ),
        ),
      ),
    );
    expect(widgetTest.find.text("2"), widgetTest.findsOneWidget);
    expect(widgetTest.find.text("subtitle"), widgetTest.findsOneWidget);
    expect(widgetTest.find.text("aaa"), widgetTest.findsNothing);
    expect(widgetTest.find.text("null"), widgetTest.findsNothing);
  });

  widgetTest.testWidgets("listview works without titleKeys",
      (widgetTest.WidgetTester tester) async {
    DocumentList dl = DocumentList("noTitleKeys");
    for (int i = 0; i < 10; i++) {
      if (i == 1) {
        dl.add(Document(initialValues: {
          "field B": "${i.toString()}",
          "field C": "subtitle"
        }));
      } else {
        dl.add(Document(initialValues: {"field B": "${i.toString()}"}));
      }
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DocumentListView(
            dl,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(widgetTest.find.text("1"), widgetTest.findsOneWidget);
  });

  widgetTest.testWidgets('test DocumentList.sort and cutomItemBuilder',
      (widgetTest.WidgetTester tester) async {
    DocumentList dl = DocumentList("sortListTest");
    dl.add(Document(initialValues: {"a": 2}));
    dl.add(Document(initialValues: {"a": 1}));
    dl.sort((a, b) => a["a"] - b["a"]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DocumentListView(
            dl,
            customItemBuilder: (int index, Document doc, BuildContext context) {
              return ListTile(
                title: Text("${index.toString()}:${doc["a"].toString()}"),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(widgetTest.find.text("0:1"), widgetTest.findsOneWidget);
    expect(widgetTest.find.text("1:2"), widgetTest.findsOneWidget);
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

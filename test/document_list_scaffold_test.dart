import 'package:flutter_test/flutter_test.dart' as widgetTest;
import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:flutter/services.dart';
import 'package:rapido/document_list.dart';
import "package:test/test.dart";

void main() {
  widgetTest.testWidgets("DocumentListViewScaffold works without title",
      (widgetTest.WidgetTester tester) async {
    DocumentList dl = DocumentList("No Title");
    await tester.pumpWidget(
      MaterialApp(
        home: DocumentListScaffold(dl),
      ),
    );
    await tester.pumpAndSettle();
    expect(widgetTest.find.text("No Title"), widgetTest.findsOneWidget);
  });

  widgetTest.testWidgets("DocumentListViewScaffold works with title",
      (widgetTest.WidgetTester tester) async {
    DocumentList dl = DocumentList("No Title");
    await tester.pumpWidget(
      MaterialApp(
        home: DocumentListScaffold(dl, title: "ABCD"),
      ),
    );
    await tester.pumpAndSettle();
    expect(widgetTest.find.text("ABCD"), widgetTest.findsOneWidget);
  });
}

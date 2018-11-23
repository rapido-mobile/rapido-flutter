import 'package:flutter_test/flutter_test.dart' as widgetTest;
import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';
import "package:test/test.dart";

void main() {
  widgetTest.testWidgets("FAB works without a title",
      (widgetTest.WidgetTester tester) async {
    DocumentList dl = DocumentList("FAB Test");
    await tester.pumpWidget(
      MaterialApp(
        home: DocumentListScaffold(dl),
      ),
    );
    await tester.pumpAndSettle();
    expect(widgetTest.find.byType(FloatingActionButton), widgetTest.findsOneWidget);
  });

    widgetTest.testWidgets("Fab works with a title",
      (widgetTest.WidgetTester tester) async {
    DocumentList dl = DocumentList("FAB Test");
    await tester.pumpWidget(
      MaterialApp(
        home: DocumentListScaffold(dl, addActionLabel: "Fab Title"),
      ),
    );
    await tester.pumpAndSettle();
    expect(widgetTest.find.byType(FloatingActionButton), widgetTest.findsOneWidget);
  });

}
import 'package:flutter_test/flutter_test.dart' as widgetTest;
import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:flutter/services.dart';
import 'package:rapido/rapido.dart';
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
    expect(widgetTest.find.text("No Title"), widgetTest.findsNothing);
  });

  widgetTest.testWidgets("test addtional actions",(widgetTest.WidgetTester tester) async {
 DocumentList dl = DocumentList("Action");
    await tester.pumpWidget(
      MaterialApp(
        home: DocumentListScaffold(dl, additionalActions: <Widget>[Text("XX")],),
      ),
    );
    await tester.pumpAndSettle();
    expect(widgetTest.find.text("XX"), widgetTest.findsOneWidget);
  } );
}

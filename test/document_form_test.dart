import 'package:flutter_test/flutter_test.dart' as widgetTest;
import 'package:flutter/material.dart';
import 'package:rapido/document_list.dart';
import "package:test/test.dart";

void main() {
  String dateTimeString = "Sat, Nov 24, 2018 12:07:37";
  String dateString = "11/24/2018";

  widgetTest.testWidgets("Datetime and date display",
      (widgetTest.WidgetTester tester) async {
    DocumentList testList = DocumentList("formTest");
    testList.addAll([
      {"datetime": dateTimeString, "date": dateString}
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: DocumentForm(testList, index: 0),
      ),
    );
    expect(widgetTest.find.text(dateTimeString), widgetTest.findsOneWidget);
    expect(widgetTest.find.text(dateString), widgetTest.findsOneWidget);
  });
}

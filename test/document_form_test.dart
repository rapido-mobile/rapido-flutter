import 'package:flutter_test/flutter_test.dart' as widgetTest;
import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';
import "package:test/test.dart";

void main() {
  String dateTimeString = "Sat, Nov 24, 2018 12:07:37";
  String dateString = "11/24/2018";

  widgetTest.testWidgets("Datetime and date display",
      (widgetTest.WidgetTester tester) async {
    DocumentList testList = DocumentList("formTest");
    Document doc = Document();
    doc["datetime"] = dateTimeString;
    doc["date"] = dateString;
    testList.addAll([doc]);
    await tester.pumpWidget(
      MaterialApp(
        home: DocumentForm(testList, document: testList[0]),
      ),
    );
    expect(widgetTest.find.text(dateTimeString), widgetTest.findsOneWidget);
    expect(widgetTest.find.text(dateString), widgetTest.findsOneWidget);
  });

  widgetTest.testWidgets('test text form',
      (widgetTest.WidgetTester tester) async {
    DocumentList testList =
        DocumentList("title test", labels: {"Title": "title"});
    await tester.pumpWidget(
      MaterialApp(
        home: DocumentForm(testList),
      ),
    );
    expect(widgetTest.find.byType(FloatingActionButton),
        widgetTest.findsOneWidget);
    expect(widgetTest.find.byType(TextFormField),
        widgetTest.findsOneWidget); 
    await tester.enterText(widgetTest.find.byType(TextFormField), "xxxx");
    await tester.tap(widgetTest.find.byType(FloatingActionButton));
  });


}

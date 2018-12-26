import 'package:flutter_test/flutter_test.dart' as widgetTest;
import 'package:flutter/material.dart';
import 'package:rapido/documents.dart';
import "package:test/test.dart";

void main() {
  String dateTimeString = "01996.July.10 AD 12:08 PM";
  String customDateTimeFormat = "yyyyy.MMMM.dd GGG hh:mm aaa";

  widgetTest.testWidgets("Custom format String test",
      (widgetTest.WidgetTester tester) async {
    DocumentList testList = DocumentList("formTest");
    testList.addAll([
      Document(initialValues: {"datetime": dateTimeString})
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: Card(
          child: TypedInputField("datetime",
              label: "datetime",
              dateTimeFormat: customDateTimeFormat,
              initialValue: dateTimeString,
              onSaved: () {}),
        ),
      ),
    );
    expect(widgetTest.find.text(dateTimeString), widgetTest.findsOneWidget);
  });

}

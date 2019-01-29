import 'package:flutter_test/flutter_test.dart' as widgetTest;
import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';
import "package:test/test.dart";

void main() {
  String dateTimeString = "01996.July.10 AD 12:08 PM";
  String customDateTimeFormat = "yyyyy.MMMM.dd GGG hh:mm aaa";

  widgetTest.testWidgets("Custom format String test",
      (widgetTest.WidgetTester tester) async {
    DocumentList testList = DocumentList(
      "formTest",
    );
    testList.addAll([
      Document(
        initialValues: {"datetime": dateTimeString},
      )
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: Card(
          child: TypedInputField("datetime",
              fieldOptions: DateTimeFieldOptions(customDateTimeFormat),
              label: "datetime",
              initialValue: dateTimeString,
              onSaved: () {}),
        ),
      ),
    );
    expect(widgetTest.find.text(dateTimeString), widgetTest.findsOneWidget);
  });

  widgetTest.testWidgets("Test listInput option",
      (widgetTest.WidgetTester tester) async {
    DocumentList testList = DocumentList(
      "listInputTest",
    );
    testList.addAll([
      Document(initialValues: {"a": "A"}),
      Document(initialValues: {"a": "B"}),
      Document(initialValues: {"a": "C"}),
      Document(initialValues: {"a": "D"}),
      Document(initialValues: {"a": "E"}),
      Document(initialValues: {"a": "F"}),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: Card(
          child: TypedInputField("a",
              fieldOptions: InputListFieldOptions("listInputTest", "a", "a"),
              label: "AAA",
              initialValue: "F",
              onSaved: () {}),
        ),
      ),
    );
    expect(widgetTest.find.text("F"), widgetTest.findsOneWidget);
  });
}

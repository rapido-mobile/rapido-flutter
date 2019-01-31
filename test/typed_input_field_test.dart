import 'package:flutter_test/flutter_test.dart' as widgetTest;
import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';
import "package:test/test.dart";

void main() {
  String dateTimeString = "1996.July.10 AD 12:08 PM";
  String customDateTimeFormat = "yyyy.MMMM.dd GGG hh:mm aaa";

  widgetTest.testWidgets("Custom format String test",
      (widgetTest.WidgetTester tester) async {
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

  widgetTest.testWidgets("Amount field test",
      (widgetTest.WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Card(
          child: TypedInputField("amount",
              fieldOptions: DateTimeFieldOptions(customDateTimeFormat),
              label: "amount",
              initialValue: 55.05,
              onSaved: () {}),
        ),
      ),
    );
    expect(widgetTest.find.text("55.05"), widgetTest.findsOneWidget);
  });
  // widgetTest.testWidgets("Test listInput option",
  //     (widgetTest.WidgetTester tester) {
  //   DocumentList testList = DocumentList(
  //     "listInputTest",
  //   );
  //   testList.addAll([
  //     Document(initialValues: {"a": "A"}),
  //     Document(initialValues: {"a": "B"}),
  //     Document(initialValues: {"a": "C"}),
  //     Document(initialValues: {"a": "D"}),
  //     Document(initialValues: {"a": "E"}),
  //     Document(initialValues: {"a": "F"}),
  //   ]);



  
  //   tester.pumpWidget(MaterialApp(
  //     home: Card(
  //       child: ListPickerFormField(
  //         documentList: testList,
  //         displayField: "a",
  //         valueField: "a",
  //       ),
  //     ),
  //   ));

  //   expect(widgetTest.find.text("A"), widgetTest.findsOneWidget);
  //   tester.pumpWidget(MaterialApp(
  //     home: Card(
  //       child: ListPickerFormField(
  //         documentList: testList,
  //         displayField: "a",
  //         valueField: "a",
  //         initiValue: "F",
  //       ),
  //     ),
  //   ));

  //   expect(widgetTest.find.text("F"), widgetTest.findsOneWidget);
  // });
}

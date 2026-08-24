import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:maths_tables_app/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MathsTablesApp(),
      ),
    );

    // Home screen title should be present.
    expect(find.text('Maths Tables Practice'), findsOneWidget);

    // The main sections should be present.
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Maths Table Rush'), findsOneWidget);

    // Scroll the ListView to reveal the last section.
    await tester.scrollUntilVisible(
      find.text('Higher Order Maths'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Higher Order Maths'), findsOneWidget);
  });
}
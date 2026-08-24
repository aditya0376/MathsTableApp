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

    // The three main sections should be visible.
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Maths Table Rush'), findsOneWidget);
    expect(find.text('Higher Order Maths'), findsOneWidget);
  });
}
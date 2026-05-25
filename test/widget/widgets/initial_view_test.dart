import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/presentation/widgets/initial_view.dart';

import '../../helpers/test_factories.dart';

void main() {
  group('InitialView', () {
    testWidgets('shows sun icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(const InitialView()));
      await tester.pump();

      expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
    });

    testWidgets('shows prompt text', (tester) async {
      await tester.pumpWidget(buildTestWidget(const InitialView()));
      await tester.pump();

      expect(find.textContaining('輸入'), findsWidgets);
    });

    testWidgets('is not a Dialog or AlertDialog', (tester) async {
      await tester.pumpWidget(buildTestWidget(const InitialView()));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(Dialog), findsNothing);
    });
  });
}

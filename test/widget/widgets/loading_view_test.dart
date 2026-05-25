import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/presentation/widgets/loading_view.dart';

import '../../helpers/test_factories.dart';

void main() {
  group('LoadingView', () {
    testWidgets('shows CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(buildTestWidget(const LoadingView()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('is not a Dialog', (tester) async {
      await tester.pumpWidget(buildTestWidget(const LoadingView()));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('shows loading text', (tester) async {
      await tester.pumpWidget(buildTestWidget(const LoadingView()));
      await tester.pump();

      expect(find.text('資料載入中...'), findsOneWidget);
    });
  });
}

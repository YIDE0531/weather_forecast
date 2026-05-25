import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/core/error/weather_failure.dart';
import 'package:weather_forecast/presentation/widgets/error_view.dart';

import '../../helpers/test_factories.dart';

void main() {
  group('ErrorView', () {
    testWidgets('shows error icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ErrorView(failure: NetworkFailure()),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry is provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        ErrorView(failure: const NetworkFailure(), onRetry: () {}),
      ));
      await tester.pump();

      expect(find.text('重試'), findsOneWidget);
    });

    testWidgets('does not show retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ErrorView(failure: NetworkFailure()),
      ));
      await tester.pump();

      expect(find.text('重試'), findsNothing);
    });

    testWidgets('shows network error message for NetworkFailure', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ErrorView(failure: NetworkFailure()),
      ));
      await tester.pump();

      expect(find.textContaining('網路'), findsOneWidget);
    });

    testWidgets('shows auth error message for AuthFailure', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ErrorView(failure: AuthFailure()),
      ));
      await tester.pump();

      expect(find.textContaining('API'), findsOneWidget);
    });

    testWidgets('shows parse error message for ParseFailure', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ErrorView(failure: ParseFailure()),
      ));
      await tester.pump();

      expect(find.textContaining('格式'), findsOneWidget);
    });

    testWidgets('shows city name in LocationNotFoundFailure message', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ErrorView(failure: LocationNotFoundFailure('臺北市')),
      ));
      await tester.pump();

      expect(find.textContaining('臺北市'), findsOneWidget);
    });

    testWidgets('shows status code in ServerFailure message', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const ErrorView(failure: ServerFailure(statusCode: 500)),
      ));
      await tester.pump();

      expect(find.textContaining('500'), findsOneWidget);
    });

    testWidgets('calls onRetry when retry button is tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(buildTestWidget(
        ErrorView(failure: const NetworkFailure(), onRetry: () => retried = true),
      ));
      await tester.pump();

      await tester.tap(find.text('重試'));
      expect(retried, isTrue);
    });
  });
}

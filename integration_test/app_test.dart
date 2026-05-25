import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_forecast/core/error/result.dart';
import 'package:weather_forecast/core/error/weather_failure.dart';
import 'package:weather_forecast/domain/usecases/get_weather_forecast.dart';
import 'package:weather_forecast/main.dart';
import 'package:weather_forecast/presentation/widgets/error_view.dart';
import 'package:weather_forecast/presentation/widgets/initial_view.dart';
import 'package:weather_forecast/presentation/widgets/weather_loaded_view.dart';

import '../test/helpers/mocks.dart';
import '../test/helpers/test_factories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockGetWeatherForecast mockUseCase;

  setUp(() {
    mockUseCase = MockGetWeatherForecast();
    registerFallbackValue('');
  });

  Future<void> startApp(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const WeatherApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('WeatherApp integration', () {
    testWidgets('shows InitialView on startup', (tester) async {
      await startApp(tester);
      expect(find.byType(InitialView), findsOneWidget);
    });

    testWidgets('search flow: initial → loaded', (tester) async {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => Success([makeWeatherForecast()]));

      await startApp(tester, overrides: [
        getWeatherForecastProvider.overrideWithValue(mockUseCase),
      ]);

      expect(find.byType(InitialView), findsOneWidget);

      await tester.enterText(find.byType(TextField), '臺北市');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(WeatherLoadedView), findsOneWidget);
    });

    testWidgets('search flow: initial → error', (tester) async {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => const Failure(NetworkFailure()));

      await startApp(tester, overrides: [
        getWeatherForecastProvider.overrideWithValue(mockUseCase),
      ]);

      await tester.enterText(find.byType(TextField), '臺北市');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorView), findsOneWidget);
    });

    testWidgets('locale toggle switches app language', (tester) async {
      await startApp(tester);

      expect(find.text('EN'), findsOneWidget);

      await tester.tap(find.text('EN'));
      await tester.pumpAndSettle();

      expect(find.text('中'), findsOneWidget);
    });
  });
}

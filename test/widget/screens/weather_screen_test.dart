import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/core/error/weather_failure.dart';
import 'package:weather_forecast/presentation/providers/weather_notifier.dart';
import 'package:weather_forecast/presentation/providers/weather_state.dart';
import 'package:weather_forecast/presentation/screens/weather_screen.dart';
import 'package:weather_forecast/presentation/widgets/error_view.dart';
import 'package:weather_forecast/presentation/widgets/initial_view.dart';
import 'package:weather_forecast/presentation/widgets/loading_view.dart';
import 'package:weather_forecast/presentation/widgets/weather_loaded_view.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_factories.dart';

Widget buildScreen(WeatherState initialState) => buildTestWidget(
      const WeatherScreen(),
      overrides: [
        weatherNotifierProvider
            .overrideWith(() => FakeWeatherNotifier(initialState)),
      ],
    );

void main() {
  group('WeatherScreen', () {
    testWidgets('initial state shows InitialView', (tester) async {
      await tester.pumpWidget(buildScreen(const WeatherInitial()));
      await tester.pump();

      expect(find.byType(InitialView), findsOneWidget);
    });

    testWidgets('loading state shows LoadingView', (tester) async {
      await tester.pumpWidget(buildScreen(const WeatherLoading()));
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
    });

    testWidgets('loaded state shows WeatherLoadedView', (tester) async {
      await tester.pumpWidget(buildScreen(
        WeatherLoaded([makeWeatherForecast()]),
      ));
      await tester.pump();

      expect(find.byType(WeatherLoadedView), findsOneWidget);
    });

    testWidgets('error state shows ErrorView', (tester) async {
      await tester.pumpWidget(buildScreen(
        const WeatherError(NetworkFailure()),
      ));
      await tester.pump();

      expect(find.byType(ErrorView), findsOneWidget);
    });

    testWidgets('search button is disabled during loading', (tester) async {
      await tester.pumpWidget(buildScreen(const WeatherLoading()));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('search button is enabled when not loading', (tester) async {
      await tester.pumpWidget(buildScreen(const WeatherInitial()));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('locale toggle button shows EN when locale is zh', (tester) async {
      await tester.pumpWidget(buildScreen(const WeatherInitial()));
      await tester.pump();

      expect(find.text('EN'), findsOneWidget);
    });

    testWidgets('tapping locale toggle changes button text to 中', (tester) async {
      await tester.pumpWidget(buildScreen(const WeatherInitial()));
      await tester.pump();

      await tester.tap(find.text('EN'));
      await tester.pump();

      expect(find.text('中'), findsOneWidget);
    });
  });
}

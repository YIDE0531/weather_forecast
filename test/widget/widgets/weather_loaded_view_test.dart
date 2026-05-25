import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/presentation/widgets/weather_loaded_view.dart';

import '../../helpers/test_factories.dart';

Widget buildLoaded(WeatherLoadedView child) =>
    buildTestWidget(Scaffold(body: child));

void main() {
  group('WeatherLoadedView', () {
    testWidgets('single forecast shows detail view with city name', (tester) async {
      await tester.pumpWidget(buildLoaded(
        WeatherLoadedView(forecasts: [makeWeatherForecast(locationName: '臺北市')]),
      ));
      await tester.pumpAndSettle();

      expect(find.text('臺北市'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('single forecast shows a Card for each period', (tester) async {
      await tester.pumpWidget(buildLoaded(
        WeatherLoadedView(forecasts: [makeWeatherForecast(periodCount: 2)]),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('single forecast does not show list tiles', (tester) async {
      await tester.pumpWidget(buildLoaded(
        WeatherLoadedView(forecasts: [makeWeatherForecast()]),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('multiple forecasts shows all city names', (tester) async {
      final forecasts = [
        makeWeatherForecast(locationName: '臺北市'),
        makeWeatherForecast(locationName: '新北市'),
        makeWeatherForecast(locationName: '高雄市'),
      ];
      await tester.pumpWidget(buildLoaded(
        WeatherLoadedView(forecasts: forecasts),
      ));
      await tester.pumpAndSettle();

      expect(find.text('臺北市'), findsOneWidget);
      expect(find.text('新北市'), findsOneWidget);
      expect(find.text('高雄市'), findsOneWidget);
    });

    testWidgets('multiple forecasts shows one ListTile per city', (tester) async {
      final forecasts = [
        makeWeatherForecast(locationName: '臺北市'),
        makeWeatherForecast(locationName: '新北市'),
      ];
      await tester.pumpWidget(buildLoaded(
        WeatherLoadedView(forecasts: forecasts),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('multiple forecasts does not show period Cards', (tester) async {
      final forecasts = [
        makeWeatherForecast(locationName: '臺北市'),
        makeWeatherForecast(locationName: '新北市'),
      ];
      await tester.pumpWidget(buildLoaded(
        WeatherLoadedView(forecasts: forecasts),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('tapping city in list triggers onCityTap callback', (tester) async {
      String? tappedCity;
      final forecasts = [
        makeWeatherForecast(locationName: '臺北市'),
        makeWeatherForecast(locationName: '新北市'),
      ];
      await tester.pumpWidget(buildLoaded(
        WeatherLoadedView(
          forecasts: forecasts,
          onCityTap: (city) => tappedCity = city,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('新北市'));
      expect(tappedCity, '新北市');
    });
  });
}

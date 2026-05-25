import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/data/models/location_model.dart';
import 'package:weather_forecast/data/models/time_period_model.dart';
import 'package:weather_forecast/data/models/weather_element_model.dart';
import 'package:weather_forecast/domain/entities/weather_forecast.dart';
import 'package:weather_forecast/domain/entities/weather_period.dart';
import 'package:weather_forecast/l10n/app_localizations.dart';

TimePeriodModel makeTimePeriod({
  String startTime = '2024-01-01 06:00:00',
  String endTime = '2024-01-01 18:00:00',
  String paramName = 'value',
  String? paramValue,
}) =>
    TimePeriodModel(
      startTime: startTime,
      endTime: endTime,
      parameter: ParameterModel(
        parameterName: paramName,
        parameterValue: paramValue,
      ),
    );

WeatherElementModel makeElement(
  String name, {
  String paramName = 'value',
  String? paramValue,
  int count = 3,
}) =>
    WeatherElementModel(
      elementName: name,
      time: List.generate(
        count,
        (i) => makeTimePeriod(
          startTime: '2024-01-0${i + 1} 06:00:00',
          endTime: '2024-01-0${i + 1} 18:00:00',
          paramName: paramName,
          paramValue: paramValue,
        ),
      ),
    );

LocationModel makeLocationModel({
  String name = '臺北市',
  int periods = 3,
}) =>
    LocationModel(
      locationName: name,
      weatherElement: [
        makeElement('Wx', paramName: '多雲', paramValue: '02', count: periods),
        makeElement('MaxT', paramName: '28', count: periods),
        makeElement('MinT', paramName: '22', count: periods),
        makeElement('CI', paramName: '舒適至悶熱', count: periods),
        makeElement('PoP', paramName: '20', count: periods),
      ],
    );

WeatherPeriod makeWeatherPeriod({
  DateTime? startTime,
  DateTime? endTime,
  String weatherDescription = '多雲',
  String weatherCode = '02',
  int maxTemperature = 28,
  int minTemperature = 22,
  String comfortIndex = '舒適至悶熱',
  int precipitationProbability = 20,
}) =>
    WeatherPeriod(
      startTime: startTime ?? DateTime(2024, 1, 1, 6),
      endTime: endTime ?? DateTime(2024, 1, 1, 18),
      weatherDescription: weatherDescription,
      weatherCode: weatherCode,
      maxTemperature: maxTemperature,
      minTemperature: minTemperature,
      comfortIndex: comfortIndex,
      precipitationProbability: precipitationProbability,
    );

WeatherForecast makeWeatherForecast({
  String locationName = '臺北市',
  int periodCount = 3,
}) =>
    WeatherForecast(
      locationName: locationName,
      periods: List.generate(
        periodCount,
        (i) => makeWeatherPeriod(
          startTime: DateTime(2024, 1, i + 1, 6),
          endTime: DateTime(2024, 1, i + 1, 18),
        ),
      ),
    );

Widget buildTestWidget(
  Widget child, {
  List<Override> overrides = const [],
  Locale locale = const Locale('zh'),
}) =>
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: child,
      ),
    );

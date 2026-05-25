import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/data/mappers/weather_mapper.dart';
import 'package:weather_forecast/data/models/location_model.dart';

import '../../../helpers/test_factories.dart';

void main() {
  group('WeatherMapper.toEntity', () {
    test('maps valid LocationModel to WeatherForecast', () {
      final model = makeLocationModel(name: '臺北市', periods: 3);
      final forecast = WeatherMapper.toEntity(model);

      expect(forecast.locationName, '臺北市');
      expect(forecast.periods, hasLength(3));
    });

    test('maps weather description and code from Wx element', () {
      final model = makeLocationModel();
      final forecast = WeatherMapper.toEntity(model);

      expect(forecast.periods.first.weatherDescription, '多雲');
      expect(forecast.periods.first.weatherCode, '02');
    });

    test('maps temperatures from MaxT and MinT elements', () {
      final model = makeLocationModel();
      final forecast = WeatherMapper.toEntity(model);

      expect(forecast.periods.first.maxTemperature, 28);
      expect(forecast.periods.first.minTemperature, 22);
    });

    test('maps precipitation probability from PoP element', () {
      final model = makeLocationModel();
      final forecast = WeatherMapper.toEntity(model);

      expect(forecast.periods.first.precipitationProbability, 20);
    });

    test('maps comfort index from CI element', () {
      final model = makeLocationModel();
      final forecast = WeatherMapper.toEntity(model);

      expect(forecast.periods.first.comfortIndex, '舒適至悶熱');
    });

    test('parses startTime and endTime as DateTime', () {
      final model = makeLocationModel();
      final forecast = WeatherMapper.toEntity(model);

      expect(forecast.periods.first.startTime, DateTime(2024, 1, 1, 6));
      expect(forecast.periods.first.endTime, DateTime(2024, 1, 1, 18));
    });

    test('fallback to 0 when temperature is not a number', () {
      final model = LocationModel(
        locationName: '臺北市',
        weatherElement: [
          makeElement('Wx', paramName: '多雲', paramValue: '02'),
          makeElement('MaxT', paramName: 'N/A'),
          makeElement('MinT', paramName: 'N/A'),
          makeElement('CI', paramName: '舒適'),
          makeElement('PoP', paramName: '20'),
        ],
      );
      final forecast = WeatherMapper.toEntity(model);

      expect(forecast.periods.first.maxTemperature, 0);
      expect(forecast.periods.first.minTemperature, 0);
    });

    test('weatherCode defaults to empty string when parameterValue is null', () {
      final model = LocationModel(
        locationName: '臺北市',
        weatherElement: [
          makeElement('Wx', paramName: '多雲', paramValue: null),
          makeElement('MaxT', paramName: '28'),
          makeElement('MinT', paramName: '22'),
          makeElement('CI', paramName: '舒適'),
          makeElement('PoP', paramName: '20'),
        ],
      );
      final forecast = WeatherMapper.toEntity(model);

      expect(forecast.periods.first.weatherCode, '');
    });

    test('throws FormatException when required element is missing', () {
      final modelMissingWx = LocationModel(
        locationName: '臺北市',
        weatherElement: [
          makeElement('MaxT', paramName: '28'),
          makeElement('MinT', paramName: '22'),
          makeElement('CI', paramName: '舒適'),
          makeElement('PoP', paramName: '20'),
        ],
      );
      expect(
        () => WeatherMapper.toEntity(modelMissingWx),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when all elements are missing', () {
      final emptyModel = LocationModel(
        locationName: '臺北市',
        weatherElement: [],
      );
      expect(
        () => WeatherMapper.toEntity(emptyModel),
        throwsA(isA<FormatException>()),
      );
    });
  });
}

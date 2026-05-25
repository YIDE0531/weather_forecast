import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/data/models/weather_response_model.dart';

void main() {
  final baseJson = {
    'records': {
      'location': [
        {
          'locationName': '臺北市',
          'weatherElement': [],
        }
      ],
    },
  };

  group('WeatherResponseModel.fromJson', () {
    test('parses success as string "true"', () {
      final model = WeatherResponseModel.fromJson({
        ...baseJson,
        'success': 'true',
      });
      expect(model.success, isTrue);
    });

    test('parses success as bool true', () {
      final model = WeatherResponseModel.fromJson({
        ...baseJson,
        'success': true,
      });
      expect(model.success, isTrue);
    });

    test('parses success as string "false"', () {
      final model = WeatherResponseModel.fromJson({
        ...baseJson,
        'success': 'false',
      });
      expect(model.success, isFalse);
    });

    test('parses locations list', () {
      final model = WeatherResponseModel.fromJson({
        'success': 'true',
        'records': {
          'location': [
            {'locationName': '臺北市', 'weatherElement': []},
            {'locationName': '新北市', 'weatherElement': []},
          ],
        },
      });
      expect(model.locations, hasLength(2));
      expect(model.locations.first.locationName, '臺北市');
    });

    test('parses empty locations list', () {
      final model = WeatherResponseModel.fromJson({
        'success': 'true',
        'records': {'location': []},
      });
      expect(model.locations, isEmpty);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/data/models/location_model.dart';

void main() {
  group('LocationModel.fromJson', () {
    test('parses locationName and weatherElement list', () {
      final model = LocationModel.fromJson({
        'locationName': '臺北市',
        'weatherElement': [
          {
            'elementName': 'Wx',
            'time': [
              {
                'startTime': '2024-01-01 06:00:00',
                'endTime': '2024-01-01 18:00:00',
                'parameter': {
                  'parameterName': '多雲',
                  'parameterValue': '02',
                },
              }
            ],
          }
        ],
      });
      expect(model.locationName, '臺北市');
      expect(model.weatherElement, hasLength(1));
      expect(model.weatherElement.first.elementName, 'Wx');
    });

    test('parses empty weatherElement list', () {
      final model = LocationModel.fromJson({
        'locationName': '臺北市',
        'weatherElement': [],
      });
      expect(model.weatherElement, isEmpty);
    });
  });
}

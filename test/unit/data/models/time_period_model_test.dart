import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/data/models/time_period_model.dart';

void main() {
  group('ParameterModel.fromJson', () {
    test('parses parameterName and parameterValue', () {
      final model = ParameterModel.fromJson({
        'parameterName': '多雲',
        'parameterValue': '02',
      });
      expect(model.parameterName, '多雲');
      expect(model.parameterValue, '02');
    });

    test('parameterValue can be null', () {
      final model = ParameterModel.fromJson({
        'parameterName': '28',
        'parameterValue': null,
      });
      expect(model.parameterValue, isNull);
    });
  });

  group('TimePeriodModel.fromJson', () {
    test('parses all fields', () {
      final model = TimePeriodModel.fromJson({
        'startTime': '2024-01-01 06:00:00',
        'endTime': '2024-01-01 18:00:00',
        'parameter': {
          'parameterName': '多雲',
          'parameterValue': '02',
        },
      });
      expect(model.startTime, '2024-01-01 06:00:00');
      expect(model.endTime, '2024-01-01 18:00:00');
      expect(model.parameter.parameterName, '多雲');
      expect(model.parameter.parameterValue, '02');
    });
  });
}

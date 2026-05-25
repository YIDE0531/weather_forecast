import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_forecast/core/error/result.dart';
import 'package:weather_forecast/domain/usecases/get_weather_forecast.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_factories.dart';

void main() {
  late MockWeatherRepository mockRepository;
  late GetWeatherForecast useCase;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetWeatherForecast(mockRepository);

    when(() => mockRepository.getForecasts(
          locationName: any(named: 'locationName'),
        )).thenAnswer((_) async => Success([makeWeatherForecast()]));
  });

  group('GetWeatherForecast', () {
    test('passes trimmed locationName to repository', () async {
      await useCase('  臺北市  ');

      verify(() => mockRepository.getForecasts(locationName: '臺北市')).called(1);
    });

    test('passes null to repository when locationName is empty string', () async {
      await useCase('');

      verify(() => mockRepository.getForecasts(locationName: null)).called(1);
    });

    test('passes null to repository when locationName is all whitespace', () async {
      await useCase('   ');

      verify(() => mockRepository.getForecasts(locationName: null)).called(1);
    });

    test('returns repository result', () async {
      final forecasts = [makeWeatherForecast(), makeWeatherForecast(locationName: '新北市')];
      when(() => mockRepository.getForecasts(locationName: any(named: 'locationName')))
          .thenAnswer((_) async => Success(forecasts));

      final result = await useCase('臺北市');

      expect((result as Success).value, hasLength(2));
    });
  });
}

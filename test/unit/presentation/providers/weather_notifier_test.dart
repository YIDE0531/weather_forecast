import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_forecast/core/error/result.dart';
import 'package:weather_forecast/core/error/weather_failure.dart';
import 'package:weather_forecast/domain/usecases/get_weather_forecast.dart';
import 'package:weather_forecast/presentation/providers/weather_notifier.dart';
import 'package:weather_forecast/presentation/providers/weather_state.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_factories.dart';

void main() {
  late MockGetWeatherForecast mockUseCase;
  late ProviderContainer container;

  setUp(() {
    mockUseCase = MockGetWeatherForecast();
    container = ProviderContainer(overrides: [
      getWeatherForecastProvider.overrideWithValue(mockUseCase),
    ]);
    addTearDown(container.dispose);
  });

  group('WeatherNotifier', () {
    test('initial state is WeatherInitial', () {
      expect(container.read(weatherNotifierProvider), isA<WeatherInitial>());
    });

    test('search() transitions to WeatherLoading then WeatherLoaded on success', () async {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => Success([makeWeatherForecast()]));

      final future = container.read(weatherNotifierProvider.notifier).search('臺北市');

      expect(container.read(weatherNotifierProvider), isA<WeatherLoading>());

      await future;

      expect(container.read(weatherNotifierProvider), isA<WeatherLoaded>());
      final loaded = container.read(weatherNotifierProvider) as WeatherLoaded;
      expect(loaded.forecasts, hasLength(1));
    });

    test('search() transitions to WeatherError on failure', () async {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => const Failure(NetworkFailure()));

      await container.read(weatherNotifierProvider.notifier).search('臺北市');

      expect(container.read(weatherNotifierProvider), isA<WeatherError>());
      final error = container.read(weatherNotifierProvider) as WeatherError;
      expect(error.failure, isA<NetworkFailure>());
    });

    test('reset() returns state to WeatherInitial', () async {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => Success([makeWeatherForecast()]));

      await container.read(weatherNotifierProvider.notifier).search('臺北市');
      expect(container.read(weatherNotifierProvider), isA<WeatherLoaded>());

      container.read(weatherNotifierProvider.notifier).reset();
      expect(container.read(weatherNotifierProvider), isA<WeatherInitial>());
    });

    test('search() passes city name to use case', () async {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => Success([makeWeatherForecast()]));

      await container.read(weatherNotifierProvider.notifier).search('高雄市');

      verify(() => mockUseCase('高雄市')).called(1);
    });
  });
}

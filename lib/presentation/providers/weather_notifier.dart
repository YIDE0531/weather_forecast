import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/result.dart';
import '../../domain/usecases/get_weather_forecast.dart';
import 'weather_state.dart';

class WeatherNotifier extends Notifier<WeatherState> {
  @override
  WeatherState build() => const WeatherInitial();

  Future<void> search(String cityName) async {
    state = const WeatherLoading();

    final result = await ref.read(getWeatherForecastProvider)(cityName);

    state = switch (result) {
      Success(:final value) => WeatherLoaded(value),
      Failure(:final failure) => WeatherError(failure),
    };
  }

  void reset() => state = const WeatherInitial();
}

final weatherNotifierProvider = NotifierProvider<WeatherNotifier, WeatherState>(
  WeatherNotifier.new,
);

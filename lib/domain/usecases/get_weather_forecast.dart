import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/weather_forecast.dart';
import '../repositories/weather_repository.dart';
import '../../core/error/result.dart';
import '../../data/repositories/weather_repository_impl.dart';

class GetWeatherForecast {
  const GetWeatherForecast(this._repository);

  final WeatherRepository _repository;

  Future<Result<List<WeatherForecast>>> call(String locationName) {
    final trimmed = locationName.trim();
    return _repository.getForecasts(
      locationName: trimmed.isEmpty ? null : trimmed,
    );
  }
}

final getWeatherForecastProvider = Provider<GetWeatherForecast>(
  (ref) => GetWeatherForecast(ref.watch(weatherRepositoryProvider)),
);

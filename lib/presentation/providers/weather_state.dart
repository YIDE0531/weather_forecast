import '../../core/error/weather_failure.dart';
import '../../domain/entities/weather_forecast.dart';

sealed class WeatherState {
  const WeatherState();
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

final class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

final class WeatherLoaded extends WeatherState {
  const WeatherLoaded(this.forecasts);
  final List<WeatherForecast> forecasts;
}

final class WeatherError extends WeatherState {
  const WeatherError(this.failure);
  final WeatherFailure failure;
}

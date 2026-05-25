import '../entities/weather_forecast.dart';
import '../../core/error/result.dart';

abstract interface class WeatherRepository {
  Future<Result<List<WeatherForecast>>> getForecasts({String? locationName});
}

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_forecast/data/datasources/weather_remote_data_source.dart';
import 'package:weather_forecast/domain/repositories/weather_repository.dart';
import 'package:weather_forecast/domain/usecases/get_weather_forecast.dart';
import 'package:weather_forecast/presentation/providers/weather_notifier.dart';
import 'package:weather_forecast/presentation/providers/weather_state.dart';

class MockDio extends Mock implements Dio {}

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockGetWeatherForecast extends Mock implements GetWeatherForecast {}

class FakeWeatherNotifier extends WeatherNotifier {
  FakeWeatherNotifier(this._initial);
  final WeatherState _initial;

  @override
  WeatherState build() => _initial;

  @override
  Future<void> search(String cityName) async {}

  @override
  void reset() {}
}

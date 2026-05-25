sealed class WeatherFailure {
  const WeatherFailure();
}

final class NetworkFailure extends WeatherFailure {
  const NetworkFailure();
}

final class LocationNotFoundFailure extends WeatherFailure {
  const LocationNotFoundFailure(this.cityName);
  final String cityName;
}

final class ServerFailure extends WeatherFailure {
  const ServerFailure({required this.statusCode});
  final int statusCode;
}

final class ParseFailure extends WeatherFailure {
  const ParseFailure();
}

final class AuthFailure extends WeatherFailure {
  const AuthFailure();
}

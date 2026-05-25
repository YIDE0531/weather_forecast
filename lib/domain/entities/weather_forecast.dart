import 'weather_period.dart';

class WeatherForecast {
  const WeatherForecast({
    required this.locationName,
    required this.periods,
  });

  final String locationName;
  final List<WeatherPeriod> periods;
}

class WeatherPeriod {
  const WeatherPeriod({
    required this.startTime,
    required this.endTime,
    required this.weatherDescription,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
    required this.comfortIndex,
    required this.precipitationProbability,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String weatherDescription;
  final String weatherCode;
  final int maxTemperature;
  final int minTemperature;
  final String comfortIndex;
  final int precipitationProbability;
}

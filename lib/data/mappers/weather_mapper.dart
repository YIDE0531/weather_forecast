import '../models/location_model.dart';
import '../models/weather_element_model.dart';
import '../../domain/entities/weather_forecast.dart';
import '../../domain/entities/weather_period.dart';

class WeatherMapper {
  WeatherMapper._();

  static WeatherElementModel? _elementByName(LocationModel model, String name) =>
      model.weatherElement.where((e) => e.elementName == name).firstOrNull;

  static WeatherForecast toEntity(LocationModel model) {
    final wxEl = _elementByName(model, 'Wx');
    final maxTEl = _elementByName(model, 'MaxT');
    final minTEl = _elementByName(model, 'MinT');
    final ciEl = _elementByName(model, 'CI');
    final popEl = _elementByName(model, 'PoP');

    if (wxEl == null || maxTEl == null || minTEl == null || ciEl == null || popEl == null) {
      throw const FormatException('Missing required weather elements');
    }

    final count = wxEl.time.length;
    final periods = List.generate(count, (i) {
      final wx = wxEl.time[i];
      final maxT = maxTEl.time[i];
      final minT = minTEl.time[i];
      final ci = ciEl.time[i];
      final pop = popEl.time[i];

      return WeatherPeriod(
        startTime: DateTime.parse(wx.startTime),
        endTime: DateTime.parse(wx.endTime),
        weatherDescription: wx.parameter.parameterName,
        weatherCode: wx.parameter.parameterValue ?? '',
        maxTemperature: int.tryParse(maxT.parameter.parameterName) ?? 0,
        minTemperature: int.tryParse(minT.parameter.parameterName) ?? 0,
        comfortIndex: ci.parameter.parameterName,
        precipitationProbability: int.tryParse(pop.parameter.parameterName) ?? 0,
      );
    });

    return WeatherForecast(locationName: model.locationName, periods: periods);
  }
}

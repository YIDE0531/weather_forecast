import 'time_period_model.dart';

class WeatherElementModel {
  const WeatherElementModel({
    required this.elementName,
    required this.time,
  });

  final String elementName;
  final List<TimePeriodModel> time;

  factory WeatherElementModel.fromJson(Map<String, dynamic> json) =>
      WeatherElementModel(
        elementName: json['elementName'] as String,
        time: (json['time'] as List<dynamic>)
            .map((e) => TimePeriodModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

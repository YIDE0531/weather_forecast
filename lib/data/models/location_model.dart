import 'weather_element_model.dart';

class LocationModel {
  const LocationModel({
    required this.locationName,
    required this.weatherElement,
  });

  final String locationName;
  final List<WeatherElementModel> weatherElement;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        locationName: json['locationName'] as String,
        weatherElement: (json['weatherElement'] as List<dynamic>)
            .map((e) => WeatherElementModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

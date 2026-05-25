import 'location_model.dart';

class WeatherResponseModel {
  const WeatherResponseModel({
    required this.success,
    required this.locations,
  });

  final bool success;
  final List<LocationModel> locations;

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    final records = json['records'] as Map<String, dynamic>;
    return WeatherResponseModel(
      success: json['success'] == 'true' || json['success'] == true,
      locations: (records['location'] as List<dynamic>)
          .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

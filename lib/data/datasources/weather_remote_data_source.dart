import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/weather_response_model.dart';

abstract interface class WeatherRemoteDataSource {
  Future<WeatherResponseModel> fetchForecasts({String? locationName});
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  const WeatherRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<WeatherResponseModel> fetchForecasts({String? locationName}) async {
    final response = await _dio.get(
      ApiConstants.forecastEndpoint,
      queryParameters: locationName != null ? {'locationName': locationName} : null,
    );
    return WeatherResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>(
  (ref) => WeatherRemoteDataSourceImpl(ref.watch(dioProvider)),
);

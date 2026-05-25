import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/result.dart';
import '../../core/error/weather_failure.dart';
import '../../domain/entities/weather_forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';
import '../mappers/weather_mapper.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl(this._dataSource);

  final WeatherRemoteDataSource _dataSource;

  @override
  Future<Result<List<WeatherForecast>>> getForecasts({
    String? locationName,
  }) async {
    try {
      final model = await _dataSource.fetchForecasts(
        locationName: locationName,
      );

      if (!model.success) {
        return Failure(const ServerFailure(statusCode: 200));
      }

      if (model.locations.isEmpty) {
        return Failure(LocationNotFoundFailure(locationName ?? ''));
      }

      final forecasts = model.locations.map(WeatherMapper.toEntity).toList();
      return Success(forecasts);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } on FormatException catch (_) {
      return const Failure(ParseFailure());
    } catch (_) {
      return const Failure(ParseFailure());
    }
  }

  WeatherFailure _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final code = e.response?.statusCode ?? 0;
        if (code == 401 || code == 403) return const AuthFailure();
        return ServerFailure(statusCode: code);

      default:
        return const NetworkFailure();
    }
  }
}

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(ref.watch(weatherRemoteDataSourceProvider)),
);

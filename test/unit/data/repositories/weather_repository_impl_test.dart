import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_forecast/core/error/result.dart';
import 'package:weather_forecast/core/error/weather_failure.dart';
import 'package:weather_forecast/data/models/location_model.dart';
import 'package:weather_forecast/data/models/weather_response_model.dart';
import 'package:weather_forecast/data/repositories/weather_repository_impl.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_factories.dart';

DioException makeDioException(DioExceptionType type, {int? statusCode}) =>
    DioException(
      type: type,
      requestOptions: RequestOptions(path: ''),
      response: statusCode != null
          ? Response(statusCode: statusCode, requestOptions: RequestOptions(path: ''))
          : null,
    );

void main() {
  late MockWeatherRemoteDataSource mockDataSource;
  late WeatherRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockWeatherRemoteDataSource();
    repository = WeatherRepositoryImpl(mockDataSource);
  });

  void stubFetch(Future<WeatherResponseModel> Function() answer) {
    when(() => mockDataSource.fetchForecasts(
          locationName: any(named: 'locationName'),
        )).thenAnswer((_) => answer());
  }

  group('WeatherRepositoryImpl.getForecasts', () {
    test('returns Success with forecasts on valid response', () async {
      stubFetch(() async => WeatherResponseModel(
            success: true,
            locations: [makeLocationModel()],
          ));

      final result = await repository.getForecasts(locationName: '臺北市');

      expect(result, isA<Success<dynamic>>());
      expect((result as Success).value, hasLength(1));
    });

    test('returns Failure(ServerFailure) when model.success is false', () async {
      stubFetch(() async => const WeatherResponseModel(success: false, locations: []));

      final result = await repository.getForecasts(locationName: '臺北市');

      expect((result as Failure).failure, isA<ServerFailure>());
    });

    test('returns Failure(LocationNotFoundFailure) when locations is empty', () async {
      stubFetch(() async => const WeatherResponseModel(success: true, locations: []));

      final result = await repository.getForecasts(locationName: '不存在');

      expect((result as Failure).failure, isA<LocationNotFoundFailure>());
    });

    test('returns Failure(ParseFailure) when mapper throws FormatException', () async {
      stubFetch(() async => WeatherResponseModel(
            success: true,
            locations: [
              const LocationModel(locationName: '臺北市', weatherElement: []),
            ],
          ));

      final result = await repository.getForecasts(locationName: '臺北市');

      expect((result as Failure).failure, isA<ParseFailure>());
    });

    test('returns Failure(NetworkFailure) on connection timeout', () async {
      when(() => mockDataSource.fetchForecasts(
            locationName: any(named: 'locationName'),
          )).thenThrow(makeDioException(DioExceptionType.connectionTimeout));

      expect(
        (await repository.getForecasts(locationName: '臺北市') as Failure).failure,
        isA<NetworkFailure>(),
      );
    });

    test('returns Failure(NetworkFailure) on receive timeout', () async {
      when(() => mockDataSource.fetchForecasts(
            locationName: any(named: 'locationName'),
          )).thenThrow(makeDioException(DioExceptionType.receiveTimeout));

      expect(
        (await repository.getForecasts(locationName: '臺北市') as Failure).failure,
        isA<NetworkFailure>(),
      );
    });

    test('returns Failure(AuthFailure) on 401', () async {
      when(() => mockDataSource.fetchForecasts(
            locationName: any(named: 'locationName'),
          )).thenThrow(makeDioException(DioExceptionType.badResponse, statusCode: 401));

      expect(
        (await repository.getForecasts(locationName: '臺北市') as Failure).failure,
        isA<AuthFailure>(),
      );
    });

    test('returns Failure(AuthFailure) on 403', () async {
      when(() => mockDataSource.fetchForecasts(
            locationName: any(named: 'locationName'),
          )).thenThrow(makeDioException(DioExceptionType.badResponse, statusCode: 403));

      expect(
        (await repository.getForecasts(locationName: '臺北市') as Failure).failure,
        isA<AuthFailure>(),
      );
    });

    test('returns Failure(ServerFailure) with status code on other HTTP errors', () async {
      when(() => mockDataSource.fetchForecasts(
            locationName: any(named: 'locationName'),
          )).thenThrow(makeDioException(DioExceptionType.badResponse, statusCode: 500));

      final failure =
          (await repository.getForecasts(locationName: '臺北市') as Failure).failure
              as ServerFailure;
      expect(failure.statusCode, 500);
    });

    test('returns Failure(ParseFailure) on unexpected exception', () async {
      when(() => mockDataSource.fetchForecasts(
            locationName: any(named: 'locationName'),
          )).thenThrow(Exception('unexpected'));

      expect(
        (await repository.getForecasts(locationName: '臺北市') as Failure).failure,
        isA<ParseFailure>(),
      );
    });
  });
}

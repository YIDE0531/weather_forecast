import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_forecast/core/constants/api_constants.dart';
import 'package:weather_forecast/data/datasources/weather_remote_data_source.dart';

import '../../../helpers/mocks.dart';

final _validJson = {
  'success': 'true',
  'records': {
    'location': [
      {
        'locationName': '臺北市',
        'weatherElement': [],
      }
    ],
  },
};

void main() {
  late MockDio mockDio;
  late WeatherRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = WeatherRemoteDataSourceImpl(mockDio);
    registerFallbackValue(RequestOptions(path: ''));
  });

  Response<dynamic> makeResponse(Map<String, dynamic> data) => Response(
        data: data,
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiConstants.forecastEndpoint),
      );

  void stubGet(Map<String, dynamic> json) {
    when(() => mockDio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => makeResponse(json));
  }

  group('WeatherRemoteDataSourceImpl.fetchForecasts', () {
    test('calls correct endpoint', () async {
      stubGet(_validJson);

      await dataSource.fetchForecasts();

      verify(() => mockDio.get<dynamic>(
            ApiConstants.forecastEndpoint,
            queryParameters: any(named: 'queryParameters'),
          )).called(1);
    });

    test('passes locationName as query parameter', () async {
      stubGet(_validJson);

      await dataSource.fetchForecasts(locationName: '臺北市');

      verify(() => mockDio.get<dynamic>(
            any(),
            queryParameters: {'locationName': '臺北市'},
          )).called(1);
    });

    test('passes null queryParameters when locationName is null', () async {
      stubGet(_validJson);

      await dataSource.fetchForecasts();

      verify(() => mockDio.get<dynamic>(
            any(),
            queryParameters: null,
          )).called(1);
    });

    test('returns parsed WeatherResponseModel on success', () async {
      stubGet(_validJson);

      final result = await dataSource.fetchForecasts();

      expect(result.success, isTrue);
      expect(result.locations, hasLength(1));
      expect(result.locations.first.locationName, '臺北市');
    });

    test('propagates DioException', () async {
      when(() => mockDio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: ''),
      ));

      expect(
        () => dataSource.fetchForecasts(),
        throwsA(isA<DioException>()),
      );
    });
  });
}

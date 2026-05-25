import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';
import '../env/env.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        queryParameters: {'Authorization': Env.apiKey},
      ),
    );

    assert(() {
      dio.interceptors.add(LogInterceptor(
        requestBody: false,
        responseBody: true,
      ));
      return true;
    }());

    return dio;
  }
}

final dioProvider = Provider<Dio>((ref) => DioClient.create());

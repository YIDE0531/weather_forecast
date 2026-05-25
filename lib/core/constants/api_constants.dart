class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://opendata.cwa.gov.tw/api';
  static const String forecastEndpoint = '/v1/rest/datastore/F-C0032-001';
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  static String get apiKey {
    final key = dotenv.env['CWA_API_KEY'];
    assert(key != null && key.isNotEmpty, 'CWA_API_KEY is not set in .env');
    return key ?? '';
  }
}

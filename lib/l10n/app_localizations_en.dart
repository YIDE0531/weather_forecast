// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Weather Forecast';

  @override
  String get searchHint => 'City name, or leave empty for all regions';

  @override
  String get searchButton => 'Search';

  @override
  String get initialPrompt => 'Enter a city name or search all regions';

  @override
  String get initialExample => 'e.g. Taipei City — or leave empty to see all';

  @override
  String get loading => 'Loading...';

  @override
  String get forecastSubtitle => '36-hour weather forecast';

  @override
  String get allRegionsTitle => 'All Taiwan — 36-hour Forecast';

  @override
  String precipitation(int percent) {
    return 'Rain $percent%';
  }

  @override
  String get retry => 'Retry';

  @override
  String get errorNetwork =>
      'Network connection error\nPlease check your internet and try again';

  @override
  String errorLocationNotFound(String cityName) {
    return 'City \"$cityName\" not found\nPlease check the city name\n(e.g. Taipei City, New Taipei City)';
  }

  @override
  String errorServer(int statusCode) {
    return 'Server error (HTTP $statusCode)\nPlease try again later';
  }

  @override
  String get errorAuth =>
      'API authentication failed\nPlease check your API key';

  @override
  String get errorParse => 'Data format error\nUnable to parse weather data';
}

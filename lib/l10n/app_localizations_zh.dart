// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '天氣預報';

  @override
  String get searchHint => '輸入縣市名稱，留空顯示全部地區';

  @override
  String get searchButton => '確認';

  @override
  String get initialPrompt => '輸入縣市名稱，或留空查詢全台天氣';

  @override
  String get initialExample => '例如：臺北市 — 或直接點確認查看全部地區';

  @override
  String get loading => '資料載入中...';

  @override
  String get forecastSubtitle => '未來 36 小時天氣預報';

  @override
  String get allRegionsTitle => '全台天氣預報（36 小時）';

  @override
  String precipitation(int percent) {
    return '降雨 $percent%';
  }

  @override
  String get retry => '重試';

  @override
  String get errorNetwork => '網路連線問題\n請確認網路狀態後重試';

  @override
  String errorLocationNotFound(String cityName) {
    return '找不到「$cityName」的天氣資料\n請確認縣市名稱是否正確\n（例如：臺北市、新北市、高雄市）';
  }

  @override
  String errorServer(int statusCode) {
    return '伺服器錯誤 (HTTP $statusCode)\n請稍後再試';
  }

  @override
  String get errorAuth => 'API 驗證失敗\n請確認 API 金鑰是否正確';

  @override
  String get errorParse => '資料格式錯誤\n無法解析天氣資料';
}

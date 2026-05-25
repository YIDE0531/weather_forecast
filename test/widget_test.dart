import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_forecast/main.dart';

void main() {
  setUpAll(() {
    dotenv.testLoad(fileInput: 'CWA_API_KEY=test-api-key');
  });

  testWidgets('App renders WeatherScreen with search field', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: WeatherApp()),
    );

    expect(find.text('天氣預報'), findsOneWidget);
    expect(find.text('輸入縣市名稱，留空顯示全部地區'), findsOneWidget);
    expect(find.text('確認'), findsOneWidget);
  });
}

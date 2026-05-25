# 天氣預報 Weather Forecast App

一個使用 Flutter 開發的台灣天氣預報應用程式，串接中央氣象署（CWA）API 提供未來 36 小時天氣查詢功能。

## 功能

- 輸入縣市名稱查詢天氣預報
- 顯示未來 36 小時（三個 12 小時時段）的天氣資訊：
  - 天氣現象
  - 最高 / 最低溫度
  - 降雨機率
  - 舒適度指數
- 四種 UI 狀態：初始、載入中、資料展示、錯誤

## 技術架構

### Clean Architecture

```
lib/
├── core/               # 核心工具（Dio 客戶端、環境變數、錯誤類型）
├── domain/             # 業務邏輯層（Entity、Repository 介面、Use Case）
├── data/               # 資料層（Model、Mapper、DataSource、Repository 實作）
└── presentation/       # 呈現層（Riverpod Provider、Widget、Screen）
```

### 技術選型

| 功能 | 套件 |
|------|------|
| 狀態管理 | flutter_riverpod ^2.6.1（Notifier，不使用 Hook） |
| HTTP 請求 | dio ^5.8.0+1 |
| 環境變數 | flutter_dotenv ^5.2.1 |

### 四種狀態 Widget

| 狀態 | Widget | 觸發時機 |
|------|--------|----------|
| 初始 | `InitialView` | App 啟動、尚未搜尋 |
| 載入中 | `LoadingView` | 點擊確認後（inline，非 Dialog） |
| 成功 | `WeatherLoadedView` | API 回傳資料 |
| 錯誤 | `ErrorView` | 網路錯誤、城市不存在、API 錯誤等 |

### 錯誤處理（Sealed Class）

```dart
sealed class WeatherFailure {}

final class NetworkFailure extends WeatherFailure {}          // 網路連線問題
final class LocationNotFoundFailure extends WeatherFailure {} // 找不到指定城市
final class ServerFailure extends WeatherFailure {}           // HTTP 錯誤（4xx / 5xx）
final class AuthFailure extends WeatherFailure {}             // API 金鑰無效
final class ParseFailure extends WeatherFailure {}            // 資料格式錯誤
```

## 快速開始

### 1. 取得 CWA API 金鑰

至 [中央氣象署開放資料平台](https://opendata.cwa.gov.tw) 免費申請 API 金鑰。

### 2. 設定環境變數

複製範例檔並填入你的 API 金鑰：

```bash
cp .env.example .env
```

編輯 `.env`：

```env
CWA_API_KEY=你的API金鑰
```

### 3. 安裝依賴

```bash
flutter pub get
```

### 4. 執行

```bash
# Android 模擬器
flutter run

# iOS 模擬器（需 macOS + Xcode）
flutter run -d ios
```

## 使用說明

1. 在搜尋欄輸入縣市名稱（需使用繁體中文正式名稱）
2. 點擊「確認」按鈕或按鍵盤 Enter
3. 等待載入後查看天氣預報

**支援的縣市名稱範例：**

```
臺北市、新北市、桃園市、臺中市、臺南市、高雄市
基隆市、新竹市、嘉義市、新竹縣、苗栗縣、彰化縣
南投縣、雲林縣、嘉義縣、屏東縣、宜蘭縣、花蓮縣
臺東縣、澎湖縣、金門縣、連江縣
```

> 注意：請使用「臺」而非「台」（如：臺北市而非台北市）

## 測試

```bash
flutter test
```

## API 參考

- 端點：`GET https://opendata.cwa.gov.tw/api/v1/rest/datastore/F-C0032-001`
- 參數：`Authorization`（API 金鑰）、`locationName`（縣市名稱）
- 說明：[中央氣象署一般天氣預報 - 今明 36 小時天氣預報](https://opendata.cwa.gov.tw/dataset/forecast/F-C0032-001)

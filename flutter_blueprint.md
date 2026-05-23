# Flutter Frontend Blueprint (Penny Pulse)

This document is generated from the local FastAPI backend in `main.py` and describes the Flutter frontend contract and recommended implementation approach.

## API Overview

Base URL (dev): `http://192.168.18.33:8000`

Endpoints:

- `GET /` -> health/status message
- `POST /predict` -> predicts `category` and `type` from input text
- `POST /add-expense` -> predicts labels, persists an expense record, returns the saved record
- `GET /history` -> returns the most recent 20 expense records

## 1) Dart Data Models (Null-Safe)

These models match the backend JSON responses exactly, including snake_case keys like `need_want`.

Recommended packages:

- `freezed_annotation` + `freezed` (immutable models, copyWith, equality)
- `json_annotation` + `json_serializable` (JSON parsing)

Add to `pubspec.yaml`:

```yaml
dependencies:
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.11
  freezed: ^2.5.7
  json_serializable: ^6.8.0
```

### `ApiMessage` (Response from `GET /`)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_message.freezed.dart';
part 'api_message.g.dart';

@freezed
class ApiMessage with _$ApiMessage {
  const factory ApiMessage({
    required String message,
  }) = _ApiMessage;

  factory ApiMessage.fromJson(Map<String, dynamic> json) =>
      _$ApiMessageFromJson(json);
}
```

JSON example:

```json
{ "message": "Penny Pulse API is running." }
```

### `PredictResponse` (Response from `POST /predict`)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'predict_response.freezed.dart';
part 'predict_response.g.dart';

@freezed
class PredictResponse with _$PredictResponse {
  const factory PredictResponse({
    required String category,
    required String type,
  }) = _PredictResponse;

  factory PredictResponse.fromJson(Map<String, dynamic> json) =>
      _$PredictResponseFromJson(json);
}
```

JSON example:

```json
{ "category": "groceries", "type": "need" }
```

### `Expense` (Response item from `POST /add-expense` and list item from `GET /history`)

Notes:

- Backend returns `need_want` (snake_case). The Dart field is named `needWant` but serialized as `need_want`.
- Backend returns `date` as an ISO-8601 string in UTC (created via `datetime.now(timezone.utc).isoformat(timespec="seconds")`).

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
class Expense with _$Expense {
  const factory Expense({
    required int id,
    required String description,
    required double amount,
    required String category,
    @JsonKey(name: 'need_want') required String needWant,
    required DateTime date,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
```

JSON example:

```json
{
  "id": 12,
  "description": "Whole Foods salad",
  "amount": 14.75,
  "category": "groceries",
  "need_want": "need",
  "date": "2026-05-22T06:10:11+00:00"
}
```

### Request Models (Used by the service layer)

These mirror the backend request bodies and are useful for strongly-typed calls.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'predict_request.freezed.dart';
part 'predict_request.g.dart';

@freezed
class PredictRequest with _$PredictRequest {
  const factory PredictRequest({
    required String text,
  }) = _PredictRequest;

  factory PredictRequest.fromJson(Map<String, dynamic> json) =>
      _$PredictRequestFromJson(json);
}
```

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_expense_request.freezed.dart';
part 'add_expense_request.g.dart';

@freezed
class AddExpenseRequest with _$AddExpenseRequest {
  const factory AddExpenseRequest({
    required String text,
    required double amount,
  }) = _AddExpenseRequest;

  factory AddExpenseRequest.fromJson(Map<String, dynamic> json) =>
      _$AddExpenseRequestFromJson(json);
}
```

## 2) API Service Layer (HTTP Client + Endpoints)

Recommended package: `dio` (timeouts, interceptors, cancellation, better errors than `http`).

```yaml
dependencies:
  dio: ^5.7.0
```

### `ApiConfig`

```dart
class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
  });

  final String baseUrl; // e.g. http://10.0.2.2:8000 for Android emulator
}
```

### `PennyPulseApi` (single responsibility: network calls)

```dart
import 'dart:io';
import 'package:dio/dio.dart';

// Import your models:
// import 'models/api_message.dart';
// import 'models/predict_request.dart';
// import 'models/predict_response.dart';
// import 'models/add_expense_request.dart';
// import 'models/expense.dart';

class PennyPulseApi {
  PennyPulseApi({
    required ApiConfig config,
    Dio? dio,
  }) : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: config.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 10),
              headers: const {
                HttpHeaders.acceptHeader: 'application/json',
                HttpHeaders.contentTypeHeader: 'application/json',
              },
            ));

  final Dio _dio;

  Future<ApiMessage> health() async {
    final res = await _dio.get<Map<String, dynamic>>('/');
    return ApiMessage.fromJson(res.data!);
  }

  Future<PredictResponse> predict({
    required PredictRequest request,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/predict',
      data: request.toJson(),
    );
    return PredictResponse.fromJson(res.data!);
  }

  Future<Expense> addExpense({
    required AddExpenseRequest request,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/add-expense',
      data: request.toJson(),
    );
    return Expense.fromJson(res.data!);
  }

  Future<List<Expense>> history({int limit = 20}) async {
    // Backend currently returns fixed 20 items; limit is here for future extension.
    final res = await _dio.get<List<dynamic>>('/history');
    final raw = res.data ?? const [];
    return raw
        .cast<Map<String, dynamic>>()
        .map(Expense.fromJson)
        .toList(growable: false);
  }
}
```

### Error Handling (client-side)

The backend raises `HTTPException(status_code=500, detail=str(exc))` for server errors, so error bodies commonly look like:

```json
{ "detail": "Some error message" }
```

For invalid request bodies, FastAPI may return a `422` with `detail` describing validation errors. In the UI, prefer showing a user-friendly message like "Please enter a description and amount".

## 3) Architecture (Recommended for a Medium App)

Recommendation: **Clean Architecture + feature-first** layout.

Why:

- This app is data-heavy (network + local lists, possible offline use), and Clean Architecture keeps UI, state, and data concerns separate.
- It scales well as you add filtering, analytics, budgets, charts, auth, etc.

Suggested folder structure:

```
lib/
  app/
    app.dart
    router.dart
    theme/
      app_theme.dart
  core/
    config/
      api_config.dart
    errors/
      app_exception.dart
    networking/
      dio_provider.dart
    utils/
      formatters.dart
  features/
    expenses/
      data/
        datasource/
          penny_pulse_api.dart
        models/
          expense.dart
          add_expense_request.dart
          predict_request.dart
          predict_response.dart
          api_message.dart
        repositories/
          expenses_repository_impl.dart
      domain/
        repositories/
          expenses_repository.dart
        usecases/
          add_expense.dart
          get_history.dart
          predict_expense.dart
      presentation/
        screens/
          home_screen.dart
          add_expense_screen.dart
          history_screen.dart
          expense_detail_screen.dart
        state/
          expenses_controller.dart
          expenses_state.dart
        widgets/
          expense_tile.dart
          amount_field.dart
```

Notes:

- Even if the backend is small today, keeping `data/domain/presentation` separation prevents tight coupling and makes testing easy.
- If you add local caching later, it becomes a new `datasource/` + repository behavior, without changing screens.

## 4) State Management Recommendation

Recommendation: **Riverpod** (prefer `flutter_riverpod`).

Why it fits this app:

- Strong dependency injection story for `ApiConfig`, `Dio`, and repositories.
- Great for async data flows (`FutureProvider`, `AsyncNotifier`) and background refresh.
- Testable: you can override providers in unit/widget tests.
- Scales without the boilerplate of Bloc for a medium app, while being more structured than classic Provider.

Suggested packages:

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
```

Example provider wiring:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final apiConfigProvider = Provider<ApiConfig>((ref) {
  return const ApiConfig(baseUrl: 'http://10.0.2.2:8000');
});

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(apiConfigProvider);
  return Dio(BaseOptions(baseUrl: config.baseUrl));
});

final pennyPulseApiProvider = Provider<PennyPulseApi>((ref) {
  return PennyPulseApi(
    config: ref.watch(apiConfigProvider),
    dio: ref.watch(dioProvider),
  );
});
```

## 5) Screen Flow (Screens + Navigation Logic)

Minimum screens to support the current backend:

1. **HomeScreen**
   - Primary entry.
   - Shows quick "Add Expense" action.
   - Shows a small "Recent Expenses" preview (top N from history).
2. **AddExpenseScreen**
   - Inputs: `text` (description), `amount` (double).
   - Actions:
     - "Predict" (calls `POST /predict`) to preview `category` and `type`.
     - "Save" (calls `POST /add-expense`) to persist and return the saved `Expense`.
   - On success: navigate back to Home and trigger refresh of history providers.
3. **HistoryScreen**
   - Full list of last 20 expenses from `GET /history`.
   - Pull-to-refresh to re-fetch.
4. **ExpenseDetailScreen** (optional but recommended)
   - Shows a single `Expense` in a readable layout.

Navigation logic (simple and scalable):

- App start -> `HomeScreen`
- `HomeScreen` -> `AddExpenseScreen` (push)
- `HomeScreen` -> `HistoryScreen` (push)
- `HistoryScreen` -> `ExpenseDetailScreen(expense)` (push)
- `AddExpenseScreen`:
  - after successful save -> `pop()` and refresh history on `HomeScreen`

Router recommendation: `go_router` for declarative routes and deep linking once the app grows.

```yaml
dependencies:
  go_router: ^14.2.7
```

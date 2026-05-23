# Penny Pulse

Penny Pulse is a dark, fintech-style expense tracker that turns everyday
transactions into insights. It pairs a sleek mobile UI with an API that
predicts expense category and need/want type, then shows activity and budget
visuals so you can understand spending at a glance.

## Highlights

- AI-assisted categorization and need/want prediction on new expenses
- Home dashboard with balance summary and quick insights
- Activity list with filters and swipe-to-delete
- Budget analytics with category breakdowns and gauge view
- Clean architecture with Riverpod state management

## Screens

- Home: balance card, spending chart, recent transactions
- Add Expense: description and amount, AI prediction, save flow
- Activity: transaction history with filters and delete actions
- Budget: monthly/yearly summary, category breakdowns
- Detail: focused view for a single expense

## Tech Stack

- Flutter (Material 3)
- Riverpod for state management
- GoRouter for navigation
- Dio for API calls
- Freezed + JsonSerializable for models
- FlChart for charts

## API Backend

The app expects a backend with the following endpoints:

- GET / -> health
- POST /predict -> predicts category and type
- POST /add-expense -> saves expense and returns it
- GET /history -> returns recent expenses

Default dev base URL is set in [lib/core/config/api_config.dart](lib/core/config/api_config.dart).

## Project Structure (Summary)

```
lib/
	app/
		app.dart
		router.dart
		theme/
	core/
		config/
		errors/
		networking/
		theme/
		utils/
	features/
		expenses/
			data/
			domain/
			presentation/
```

## Getting Started

### Prerequisites

- Flutter SDK 3.10.7 or newer
- A running backend that matches the API contract above

### Setup

1. Install dependencies:
	 ```bash
	 flutter pub get
	 ```
2. Set your API base URL in [lib/core/config/api_config.dart](lib/core/config/api_config.dart).
3. Run the app:
	 ```bash
	 flutter run
	 ```

## App Icons and Splash Screen

Launcher icon and native splash are configured in [pubspec.yaml](pubspec.yaml).
After updating the PNG assets, run:

```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash
```

## Notes

- The UI is intentionally set to the dark theme (see [lib/app/app.dart](lib/app/app.dart)).
- The app uses a local dev IP by default; update it if your backend host changes.

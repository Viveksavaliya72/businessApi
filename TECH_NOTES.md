# TECH_NOTES

## Architecture
- Flutter (Provider for state management).
- Networking via Dio. Local JSON served via a Dio HttpClientAdapter that reads an asset (assets/data/businesses.json). This keeps networking code realistic for interview expectations while avoiding external servers.
- Persistence: shared_preferences caches the raw JSON after a successful load to provide offline support.
- UI: ListScreen (search + list), DetailScreen, BusinessCard<T> for reusability via composition.

## Key trade-offs
- Chose `shared_preferences` for simplicity (small app). For larger datasets or complex queries, Hive/SQLite would be preferable.
- Using a Dio adapter to serve assets keeps the network layer intact and testable, however in real production you'd call a real REST API and possibly use interceptors for token rotation.
- Provider is used because the assignment requires it and it's simple for this scale. For larger apps, Riverpod or BLoC could provide better DI/testability.

## Improvements with more time
- Add unit and widget tests (model parsing, provider logic, UI).
- Replace shared_preferences with Hive for typed objects and performance.
- Add pagination, caching invalidation, and request cancellation (CancelToken) in provider for long-running requests.
- Add input validation UX, internationalization (i18n), and support for RTL layouts.


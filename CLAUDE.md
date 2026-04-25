# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Analyze (no errors expected, ~50 warnings are known false positives)
flutter analyze

# Run tests
flutter test
flutter test test/widget_test.dart  # single file

# Code generation (required after modifying any @freezed model, @riverpod provider, or Drift table)
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

### Layer structure (per feature)

Each feature under `lib/features/{feature}/` follows:
- `data/dtos/` — JSON request/response classes (`@JsonSerializable`, no Freezed)
- `data/data_sources/` — raw Dio calls, throws `DioException` (caught by `ErrorInterceptor`)
- `data/repositories/` — `@riverpod` factory that wires the data source; contains the private `_Impl` class
- `domain/repositories/` — `abstract interface class` for the repository
- `presentation/providers/` — `@riverpod` `Notifier`/`AsyncNotifier` classes
- `presentation/screens/` — `ConsumerWidget` / `ConsumerStatefulWidget`

### Core providers (`lib/core/providers/core_providers.dart`)

All four are `keepAlive: true`:
- `secureStorageProvider` — `SecureStorage` (JWT + user JSON in Keystore/Keychain)
- `appDatabaseProvider` — Drift `AppDatabase`
- `serverConfigProvider` (`ServerConfig` AsyncNotifier) — persists `server_host` to `SharedPreferences`; calling `setHost()` normalises the URL, clears the JWT, and invalidates `authStateProvider`
- `dioClientProvider` — rebuilds automatically when `serverConfigProvider` changes
- `authStateProvider` (`AuthState` AsyncNotifier) — reads token+user from `SecureStorage`; `setUser()` writes both; `logout()` clears both

### Navigation (`lib/core/router/app_router.dart`)

GoRouter is itself a `keepAlive` Riverpod provider. A `_RouterNotifier extends ChangeNotifier` listens to `serverConfigProvider` and `authStateProvider` and calls `notifyListeners()` to trigger `refreshListenable`. The redirect logic is three-step:

1. No `server_host` → `/server-setup`
2. No JWT → `/auth/login`
3. Role guard: `/admin/*` requires `isSuperAdmin`; `/stores/*` and `/stock/*` require `isManager`

Routes are constants in `lib/core/router/app_routes.dart`.

### HTTP (`lib/core/api/dio_client.dart`)

All API responses are wrapped as `{"data": ...}`. Use `unwrapData<T>()` for single objects and `unwrapList<T>()` for arrays — both helpers live at the bottom of `dio_client.dart`. `ErrorInterceptor` converts every `DioException` into an `AppException` (Freezed union: `.network()` / `.unauthorized()` / `.server(code, message, status)`). Surface errors to users with `mapException(e)` from `lib/shared/utils/error_messages.dart`.

### Local cache (`lib/core/db/app_database.dart`)

Drift is used **only for products** (single `ProductsTable`). Two extension methods bridge the model/DB boundary: `ProductsTableDataX.toProduct()` and `ProductX.toCompanion()`. Cache is evicted on app start (`evictStale()`, TTL 5 min). Barcode lookup checks the cache first; list fetches write back to the cache automatically in `_ProductRepositoryImpl`.

### Models (`lib/shared/models/`)

All domain models are `@freezed` with JSON support. Each file needs:
```dart
part 'model_name.freezed.dart';
part 'model_name.g.dart';
```
`@JsonKey(name: 'snake_case')` annotations on Freezed constructor parameters trigger an `invalid_annotation_target` lint warning — this is a known false positive, do not remove them.

`User` exposes role helpers (`isManager`, `isSuperAdmin`, `isSeller`) and a localised `roleLabel`. `storeId` is `null` for managers and super-admins.

### Code generation

Any file using `@riverpod`, `@freezed`, `@JsonSerializable`, or `@DriftDatabase` needs a `part 'filename.g.dart';` directive (Freezed models also need `part 'filename.freezed.dart';`). Provider files must import both `flutter_riverpod` and `riverpod_annotation`.

### Role-based UI

`HomeShell` builds the `NavigationBar` tabs dynamically: sellers see 4 tabs, managers/admins see a 5th "Ещё" tab that leads to `MoreScreen` (stores, stock transfer, create manager for super-admins). `RoleGuard` widget hides children that require roles the current user doesn't have.

### Deployment model

The app is on-premise: each customer runs their own backend. The server URL is entered by the user on first launch (`ServerSetupScreen` pings `/health`) and stored in `SharedPreferences`. Changing the server URL resets the session.

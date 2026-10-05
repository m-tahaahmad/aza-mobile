# mobile-app (icms_app)

Flutter mobile app for ICMS — Insurance Surveyor Portal. Tenant is selected at login via the **Server** field and persisted locally.

This file is the source of truth for project context; `.cursor/rules/*.mdc` mirrors focused parts of it.

## Commands

```bash
flutter pub get

# Run — production API host (default)
flutter run -t lib/main.dart

# Run — local backend
flutter run \
  --dart-define=API_HOST=http://10.0.2.2:8000 \
  -t lib/main.dart

# Build APK
flutter build apk --release -t lib/main.dart
```

Pre-configured IDE run config: `.run/ICMS.run.xml`

## Tech stack

- **Flutter** (SDK `>=3.0.0 <4.0.0`), package name `icms_app`
- **Provider** — `ChangeNotifier` state (`lib/Providers/`)
- **http** + **dio** — API layer (`lib/Services/API/api.dart`)
- **flutter_screenutil** — responsive sizing (`designSize: Size(360, 690)`)
- **shared_preferences** — local storage (`SharedPreferencesService`)

## Configuration

| Setting | Source | Default |
|---------|--------|---------|
| API host | `API_HOST` dart-define in `lib/Env/env.dart` | `http://10.0.2.2:8000` |
| Tenant | **Server** field on login → `TenantConfig` → `globals.baseUrl` | persisted in SharedPreferences |

Full API URL: `{API_HOST}/api/v1/{server}/`

Pass `--dart-define=API_HOST=...` to override the default host. No Android product flavors.

### How tenant config works

1. **Entry point** (`lib/main.dart`) — calls `initApp()` then `runApp(const MyApp())`.
2. **`API_HOST` dart-define** — compile-time API host in `lib/Env/env.dart`.
3. **Server field** — runtime tenant slug; saved via `TenantConfig`, applied to `globals.baseUrl`.
4. **Tenant settings** — fetched after login (`SettingService.fetchPublicSettings()`), cached in `publicSettings`, colors via `ColorConstants.applyFromPublicSettings()`. On cold start, cached colors only (no settings API at startup).

`baseUrl` in `lib/constants/globals.dart` is set by `TenantConfig.restoreFromStorage()` at startup and updated on login.

## Directory layout

```
lib/
  main.dart                   # app entry point
  init_app.dart               # startup: restore tenant + cached colors
  app.dart                    # MyApp, MultiProvider registration, routing entry
  Env/
    env.dart                  # compile-time API host (apiHost, apiUrlForTenant)
  Services/
    TenantConfig/
      tenant_config.dart      # server name storage + baseUrl application
  constants/
    globals.dart              # baseUrl, tenantName, session globals
    ThemeConstants.dart       # colors from cached/fetched settings
    KeysConstants.dart        # SharedPreferences keys
    AssetConstants.dart       # image asset paths
  Model/                      # request/response DTOs (fromJson / toJson)
  Services/                   # API and side-effect logic
  Providers/                  # ChangeNotifier state per feature
  screens/                    # feature screens (grouped by domain)
  components/                 # shared reusable widgets
  HelperFunctions/            # pure helpers
```

## Development pattern

Data flows **Screen → Service → Api → Provider → UI**.

### Screens

- Place feature screens under `lib/screens/<Feature>/`.
- Complex screens often split into two files:
  - `*Screen.dart` — `StatefulWidget`, loads data in `initState`, handles refresh/navigation, calls services.
  - `*UI.dart` — presentation widgets fed by the screen (or provider state).
- Register new global providers in `app.dart` `MultiProvider`, not inside individual screens.

### Services

- One service class per API domain (e.g. `DashBoardService`, `CustomerDetailService`).
- Call `Api.getRequestData` / `Api.postRequestData` / etc. with a relative endpoint (prepended by `baseUrl`).
- Wrap results in `ApiResponse<T>` and catch exceptions from `app_exceptions.dart`.
- Update the matching `Provider` inside the service after a successful response (see `DashBoardService`).

### Providers

- Extend `ChangeNotifier`; expose getters and setter methods that call `notifyListeners()`.
- Hold parsed `Model` objects, not raw JSON.
- Screens read state via `Provider.of<T>(context)` or `context.watch<T>()`.

### Models

- Group by feature under `lib/Model/<Feature>/`.
- Implement `fromJson` factory constructors; add `toJson` when sending request bodies.
- Keep models free of `BuildContext` and widget imports.

### Components

- Reusable UI pieces live in `lib/components/` (buttons, app bars, dialogs, form fields).
- Use `ColorConstants` for theming (populated from tenant settings after login).

### API conventions

- Endpoints are relative paths appended to `baseUrl` (set by `TenantConfig`).
- Authenticated calls read the bearer token from `SharedPreferencesService` via `KeysConstants.accessToken`.
- Pass `BuildContext` to `Api` methods when logout or error dialogs are needed.

## Android specifics

- No product flavors; `applicationId` is `com.bitdatastudio.icms`, display name `ICMS`.
- Cleartext HTTP enabled in main `AndroidManifest.xml` for local `API_HOST` dev.
- Release signing requires local `android/key.properties` (gitignored).
- APK output: `build/app/outputs/flutter-apk/app-release.apk`

## Conventions

- Import shared code as `package:icms_app/...` (matches `pubspec.yaml` name).
- Match existing file/folder naming: PascalCase files, feature-grouped folders.
- Portrait-only orientation is set in `init_app.dart`.
- Do not hardcode API URLs outside `lib/Env/env.dart` and `TenantConfig`.
- Use `globals.tenantName` or `TenantConfig.getServerName()` for runtime tenant context.

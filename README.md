# ICMS App

Flutter mobile app for ICMS — Insurance Surveyor Portal. Tenant is selected at login via the **Server** field and persisted locally.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (SDK `>=2.19.0 <3.0.0`)
- Android Studio / Xcode for device emulators (optional)
- A connected device or emulator

## Setup

```bash
flutter pub get
```

## Configuration

| Setting | Source | Default |
|---------|--------|---------|
| API host | `API_HOST` dart-define | `http://10.0.2.2:8000` |
| Tenant | **Server** field on login (saved to local storage) | — |

Full API URL: `{API_HOST}/api/v1/{server}/`

Pass `--dart-define=API_HOST=...` to point at a different host (e.g. production or a physical-device LAN IP).

## Run from the command line

### Default host (Android emulator → local backend)

User enters the tenant slug on the login screen (e.g. `demo`).

```bash
flutter run -t lib/main.dart
```

### Local backend

On the Android emulator, `10.0.2.2` maps to your machine's `localhost`. Use your machine's LAN IP on a physical device.

```bash
flutter run \
  --dart-define=API_HOST=http://10.0.2.2:8000 \
  -t lib/main.dart
```

Optional: `adb reverse tcp:8000 tcp:8000` then use `http://127.0.0.1:8000` or keep `10.0.2.2`.

### Optional flags

```bash
flutter devices
flutter run -t lib/main.dart -d <device-id>
flutter run --release -t lib/main.dart
```

## Build from the command line

Release signing for Android requires `android/key.properties` (see below).

### Android APK (release)

**Production API**:
2
```bash
flutter build apk --release -t lib/main.dart
```

**Local backend**:

```bash
flutter build apk --release \
  --dart-define=API_HOST=http://10.0.2.2:8000 \
  -t lib/main.dart
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle / AAB (Play Store)

**Use this for Play Store uploads** (defaults to `https://api-beta.azawanpk.com`):

```bash
flutter build appbundle --release -t lib/main.dart
```

Output: `build/app/outputs/bundle/release/app-release.aab`

**Do not** ship an AAB built with a local/dev `API_HOST` (e.g. `http://10.0.2.2:8000` or `127.0.0.1`). That host only works on emulators/dev machines — Play reviewers will see login failures and your backend will receive no requests.

Local-backend AAB (dev only, never upload to Play):

```bash
flutter build appbundle --release \
  --dart-define=API_HOST=http://10.0.2.2:8000 \
  -t lib/main.dart
```

**Play Console testing notes** (required for review):

- **Server**: tenant slug (exact value shown on the login “Server” field), e.g. `az-awan`
- **Credentials**: a **mobile Surveyor** account (`type=mobile`), **not** a web portal employee/admin login
- Tenant must have the **`mobile_app`** feature enabled
- Reviewers must grant **Camera** and **Notification** permissions before the login screen appears

### iOS

First-time setup:

```bash
cd ios && pod install && cd ..
```

**Production API** (simulator or device):

```bash
flutter run -t lib/main.dart -d <device-id>
flutter build ios --release -t lib/main.dart
```

**Custom API host**:

```bash
# iOS Simulator (backend on same Mac)
flutter run \
  --dart-define=API_HOST=http://127.0.0.1:8000 \
  -t lib/main.dart

# Physical iPhone/iPad (use your Mac's LAN IP, same Wi‑Fi as the device)
flutter run \
  --dart-define=API_HOST=http://10.39.1.110:8000 \
  -t lib/main.dart \
  -d <ios-device-id>
```

List devices: `flutter devices`

**Notes:**
- Bundle ID: `com.bitdatastudio.icms` (set signing team in Xcode → Runner → Signing & Capabilities).
- Edge-swipe back is enabled on iOS via `CupertinoPageTransitionsBuilder`.
- Portrait-only, same as Android.
- Local HTTP is allowed via `NSAllowsLocalNetworking` in `Info.plist`.

## Login flow

1. User enters username, password, and **Server** (tenant slug).
2. Server name is saved to local storage and prefilled on next visit.
3. Mobile authenticates with `POST .../login?type=surveyor` — web portal uses `type=employee`; credentials are **not** interchangeable.
4. After successful login, tenant settings (colors) are fetched and cached.
5. Cached colors are applied on subsequent app launches without an API call at startup.

## Release signing (Android)

Release builds require `android/key.properties` with your keystore details:

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=<alias>
storeFile=<path-to-keystore>
```

This file is gitignored and must be created locally.

## IDE run configuration

Pre-configured run config in `.run/ICMS.run.xml` — local backend with `API_HOST=http://10.0.2.2:8000`.

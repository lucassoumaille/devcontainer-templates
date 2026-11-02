---
description: Android platform configuration, permissions and device features
paths:
  - "android/**"
  - "lib/**/*.dart"
---

## Project configuration
- Edit `android/app/build.gradle.kts` and `android/app/src/main/AndroidManifest.xml`; do not edit generated files (`GeneratedPluginRegistrant`, `local.properties`, `gradlew`).
- Keep `compileSdk`/`targetSdk` = `flutter.*` defaults unless a plugin requires more; Google Play requires a recent `targetSdk` (latest or latest - 1) for updates. Raise `minSdk` only when a plugin requires it, and say so.
- `applicationId` is permanent once published. `com.example.*` is rejected by Google Play.
- The main manifest declares `android.permission.INTERNET` (added by `scripts/bootstrap.sh`); without it release builds have no network.

## Permissions
- Declare only what the app uses, and explain each new permission in the change summary.
- Request runtime permissions in context (when the user triggers the feature), with `permission_handler` or the plugin's own API; handle denied and permanently denied (link to settings) states.
- Use the narrowest option: Photo Picker (`image_picker`) instead of `READ_MEDIA_IMAGES`; approximate before precise location; no `MANAGE_EXTERNAL_STORAGE`, `QUERY_ALL_PACKAGES`, `READ_SMS` without a policy-approved reason (Play reviews them).

## Device features
- **HTTP/HTTPS**: see `security.md`. Cleartext HTTP is blocked by default; do not enable `usesCleartextTraffic` globally. For a local dev server, use a debug-only `network_security_config.xml`.
- **Notifications**: `POST_NOTIFICATIONS` runtime permission (Android 13+); create notification channels; local notifications with `flutter_local_notifications`, push with Firebase Cloud Messaging (`firebase_messaging`). Exact alarms (`SCHEDULE_EXACT_ALARM`) only for alarm/calendar apps.
- **Camera / media**: `camera` for a live preview, `image_picker` for taking or choosing a photo. `CAMERA` permission only for the `camera` plugin.
- **Biometrics**: `local_auth` requires `MainActivity` to extend `FlutterFragmentActivity` and `USE_BIOMETRIC`. Biometrics unlock a local secret (e.g. a key in `flutter_secure_storage`); they are not a server-side authentication.
- **Location**: `geolocator`; foreground first. Background location needs a strong justification and a Play declaration.
- **Background work**: `workmanager` for deferrable tasks. Foreground services must declare a `foregroundServiceType` (Android 14+) and the matching permission.
- **Deep links**: Android App Links with `autoVerify` and `/.well-known/assetlinks.json` on the domain (SHA-256 of the Play app signing key).
- **Back navigation**: support predictive back (`PopScope`, no `WillPopScope`).

## Data
- Exclude secrets and tokens from auto backup (`android:dataExtractionRules` / `fullBackupContent`), or disable `allowBackup` if the app stores sensitive data.
- Do not store files outside app-specific storage unless the user exports them (MediaStore / Storage Access Framework).

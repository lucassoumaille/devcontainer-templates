---
description: Networking, storage, secrets and privacy
paths:
  - "lib/**/*.dart"
  - "android/**"
  - "ios/**"
  - "config/**"
---

## Networking
- HTTPS only. Use one HTTP client for the app (`http` or `dio`, whichever the project uses), wrapped in a service class with base URL from `AppConfig`, timeouts, and typed errors mapped to user messages.
- Never disable certificate checks (`badCertificateCallback => true`). Certificate pinning only with a documented key rotation plan.
- Parse responses into typed models; treat all server data as untrusted (null fields, unexpected values).
- Handle offline, timeout and 401 (refresh or sign out) cases explicitly.

## Secrets and configuration
- Everything in the app binary is public: `--dart-define` values, assets, `config/*.json`, `google-services.json`. Never ship private API keys, service account keys, or payment secret keys; keep them on a backend.
- Firebase config files and `firebase_options.dart` are identifiers, not secrets: they may be committed, but restrict the API keys in Google Cloud and protect data with Security Rules / App Check.
- Never commit `android/key.properties`, keystores (`*.jks`, `*.keystore`), `.p12`, provisioning profiles, or `.env` files with credentials.

## Storage
- Tokens and credentials: `flutter_secure_storage` (Android Keystore / iOS Keychain), never `shared_preferences` or plain files.
- Local databases with personal data: keep them in app-private storage; encrypt if the threat model requires it.
- Clear tokens and cached personal data on sign-out.

## Privacy
- Collect the minimum data. Keep the Play Data safety form and the App Store privacy details in sync with the SDKs added (analytics, crash reporting, ads).
- Ask consent before analytics/tracking where the law requires it (GDPR); iOS tracking requires App Tracking Transparency.
- Do not log personal data or full request/response bodies in release builds.

---
description: Versioning, signing, release builds and store publishing
paths:
  - "pubspec.yaml"
  - "android/**"
  - "ios/**"
  - ".github/workflows/**"
---

- Version in `pubspec.yaml` as `x.y.z+build`; the build number must increase for every store upload. Do not change it unless asked.
- Release builds: `flutter build appbundle --release --obfuscate --split-debug-info=build/symbols --dart-define-from-file=config/prod.json`. Keep `build/symbols` for each published version (needed to read crash stack traces).
- Android signing: `android/app/build.gradle.kts` reads `android/key.properties` (`storeFile`, `storePassword`, `keyAlias`, `keyPassword`) and falls back to the debug key when it is missing. Store the upload keystore outside the repository (e.g. `~/.android/keystores/`, which is a persistent volume in this container) and back it up. Use Play App Signing: Google holds the app signing key, the local key is only the upload key.
- Never create, move, print or commit keystores or `key.properties` yourself; tell the user the command (`keytool -genkey -v -keystore … -keyalg RSA -keysize 2048 -validity 10000 -alias upload`).
- Publish an Android App Bundle (`.aab`) to Play, not APKs. Use internal testing → closed testing → production tracks. New personal developer accounts must run a closed test before production.
- iOS release (signing, archive, TestFlight) happens on macOS or a hosted macOS CI with an Apple Developer account; fastlane can automate both stores. Do not set this up without approval.
- Do not modify CI workflows, upload builds or change store listings without explicit approval.

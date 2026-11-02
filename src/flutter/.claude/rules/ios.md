---
description: iOS configuration (built on macOS only)
paths:
  - "ios/**"
  - "lib/**/*.dart"
---

- iOS cannot be built, signed or run in this container: compile checks run on the macOS CI job (`flutter build ios --no-codesign`). Say so when a change touches iOS, and list what must be verified on a Mac or iPhone.
- Every permission needs a usage description in `ios/Runner/Info.plist`, written for the user, or the app crashes / is rejected: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSFaceIDUsageDescription`, `NSLocationWhenInUseUsageDescription`, `NSMicrophoneUsageDescription`…
- When adding a plugin that needs a permission, add the Android manifest entry and the iOS `Info.plist` key in the same change.
- Push notifications need an APNs key (Apple Developer account), the Push Notifications and Background Modes capabilities in Xcode, and the APNs key uploaded to Firebase when using FCM.
- Keep App Transport Security on (HTTPS only); no `NSAllowsArbitraryLoads`.
- Universal Links need the Associated Domains capability and `/.well-known/apple-app-site-association` on the domain.
- Keep `ios/Runner/PrivacyInfo.xcprivacy` (privacy manifest) up to date when using required-reason APIs or tracking SDKs.
- Do not edit `ios/Pods/`, `Podfile.lock` by hand or `project.pbxproj` beyond targeted settings; raise the iOS deployment target in `ios/Podfile` only when a plugin requires it.

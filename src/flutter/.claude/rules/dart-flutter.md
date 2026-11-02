---
description: Dart and Flutter code, architecture and UI conventions
paths:
  - "lib/**/*.dart"
  - "pubspec.yaml"
---

## Code
- Follow Effective Dart: `snake_case` files, `UpperCamelCase` types, `lowerCamelCase` members. Keep `dart format` output; do not hand-format.
- Sound null safety: no `!` unless the invariant is obvious from the code next to it; no `dynamic` or untyped `Map<String, dynamic>` beyond JSON decoding boundaries.
- Prefer `const` widgets, `final` locals, small widgets over helper methods returning widgets.
- After an `await` in a widget, check `context.mounted` (or `mounted`) before using `context`.
- Dispose what you create: controllers, `StreamSubscription`, `AnimationController`, `FocusNode`, timers.
- No `print`: use `dart:developer` `log` or the project's logger. Never log tokens, passwords, or personal data.

## Architecture
- Feature-first layout: `lib/features/<feature>/` (pages, widgets, view models), `lib/core/` (config, theme, routing), `lib/data/` (repositories, API clients, models) unless the project already uses another one.
- Follow Flutter's recommended layering: UI (widgets) -> view model / state -> repository -> service (HTTP, database, platform plugin). Widgets never call HTTP or plugins directly.
- Use the state management library the project already uses. With none, start with `ChangeNotifier`/`ValueNotifier`; ask before adding Riverpod, Bloc, Provider or another one.
- Navigation: `Navigator` is fine for a few screens; ask before adding `go_router` (needed for deep links / App Links and web URLs).
- Models are immutable; JSON through `json_serializable`/`freezed` code generation if the project uses it (`dart run build_runner build`); never edit `*.g.dart`/`*.freezed.dart`.

## Dependencies
- Before adding a package: check it is maintained, supports Android and iOS (pub.dev platform badges), has a compatible license, and prefer `flutter.dev`/`dart.dev`/Flutter Favorite publishers. Justify it and ask before adding.
- Add packages with `flutter pub add <name>`, commit `pubspec.lock` (this is an app).
- After adding a plugin, read its README "Android" and "iOS" setup sections: most need manifest permissions, `Info.plist` keys, or a minimum SDK.

## UI
- Material 3 with `ColorScheme.fromSeed`; support light and dark themes; no hard-coded colors or text styles outside the theme.
- Adaptive layouts: use `MediaQuery.sizeOf`/`LayoutBuilder`, do not lock orientation (Android 16 ignores it on large screens), wrap content in `SafeArea` (edge-to-edge is enforced from Android 15).
- Accessibility: tappable targets >= 48 dp, `Semantics`/`tooltip` on icon-only buttons, text that scales with the system font size, sufficient contrast.
- User-facing strings go through `gen-l10n` (`flutter_localizations` + ARB files in `lib/l10n/`) once the app has more than placeholder text.

/// Build-time configuration, injected with `--dart-define-from-file=config/<env>.json`.
///
/// These values are compiled into the app and can be extracted from it: never put
/// secrets (API keys with write access, signing keys, passwords) here.
abstract final class AppConfig {
  static const environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static bool get isProduction => environment == 'prod';
}

class AppConfig {
  /// Backend base URL (set with --dart-define=API_BASE_URL=https://your-host/api)
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );
}

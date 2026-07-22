class AppEnvironment {
  const AppEnvironment._();

  static String get apiBaseUrl {
    const configuredUrl = String.fromEnvironment('APP_API_BASE_URL');

    final String baseUrl = configuredUrl.trim().isNotEmpty
        ? configuredUrl.trim()
        : Uri.base.origin;

    if (baseUrl.endsWith('/')) {
      return baseUrl.substring(0, baseUrl.length - 1);
    }

    return baseUrl;
  }
}

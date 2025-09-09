class ApiConfig {
  // Whether to prefer Quran.Foundation content endpoints. Keep false to use existing Quran.com v4.
  static const bool useQfContent = bool.fromEnvironment('QF_USE_CONTENT', defaultValue: false);

  // OAuth2 issuer base (no trailing slash), e.g. https://prelive-oauth2.quran.foundation or https://oauth2.quran.foundation
  static const String oauthBase = String.fromEnvironment(
    'QF_OAUTH_BASE',
    defaultValue: 'https://prelive-oauth2.quran.foundation',
  );

  // Client credentials (DO NOT hardcode in source; pass via --dart-define)
  static const String clientId = String.fromEnvironment('QF_CLIENT_ID', defaultValue: '');
  static const String clientSecret = String.fromEnvironment('QF_CLIENT_SECRET', defaultValue: '');

  // Optional audience/scope if required in the future
  static const String scope = String.fromEnvironment('QF_SCOPE', defaultValue: '');

  // Content API base (if using Quran.Foundation content APIs)
  static const String qfContentBase = String.fromEnvironment(
    'QF_CONTENT_BASE',
    defaultValue: 'https://api.quran.foundation',
  );
}


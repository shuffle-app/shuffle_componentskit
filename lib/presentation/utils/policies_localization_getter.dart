class PolicyLocalizer {
  PolicyLocalizer._();

  static String localizedPrivacyPolicy(String langCode) {
    switch (langCode) {
      case 'ru':
        return 'https://shuffle.city/ru/privacy.html';
      case 'en':
        return 'https://shuffle.city/privacy.html';
      case 'hi':
        return 'https://shuffle.city/in/privacy.html';
      default:
        return 'https://shuffle.city/privacy.html';
    }
  }

  static String localizedTermsOfService(String langCode) {
    switch (langCode) {
      case 'ru':
        return 'https://shuffle.city/ru/terms.html';
      case 'en':
        return 'https://shuffle.city/terms.html';
      case 'hi':
        return 'https://shuffle.city/in/terms.html';
      default:
        return 'https://shuffle.city/terms.html';
    }
  }
}

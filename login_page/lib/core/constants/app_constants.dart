class AppConstants {
  static const String appName = 'AuthApp';
  
  // SharedPreferences keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  
  // API endpoints (if you'll add API later)
  static const String baseUrl = 'https://your-api.com';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
}
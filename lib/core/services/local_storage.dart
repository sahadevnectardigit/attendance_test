import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  /// Store access & refresh tokens
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  /// Clear tokens
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
  }

  /// --- Remember Me flag ---
  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value);
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember_me') ?? false;
  }

  /// Clear remember me preference
  static Future<void> clearRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');
  }

  /// --- User credentials for auto-fill (optional convenience feature) ---
  static Future<void> saveUserCredentials({
    required String email,
    required String companyCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
    await prefs.setString('saved_company_code', companyCode);
  }

  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_email');
  }

  static Future<String?> getSavedCompanyCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_company_code');
  }

  static Future<void> clearUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_email');
    await prefs.remove('saved_company_code');
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

// class LocalStorage {
//   /// Store access & refresh tokens
//   static Future<void> saveTokens({
//     required String accessToken,
//     required String refreshToken,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', accessToken);
//     await prefs.setString('refresh_token', refreshToken);
//   }

//   /// Get access token
//   static Future<String?> getAccessToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   /// Get refresh token
//   static Future<String?> getRefreshToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('refresh_token');
//   }

//   /// Clear tokens
//   static Future<void> clearTokens() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.remove('refresh_token');
//   }

//   /// --- Remember Me flag ---
//   static Future<void> setRememberMe(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('remember_me', value);
//   }

//   static Future<bool> getRememberMe() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('remember_me') ?? false;
//   }
// }

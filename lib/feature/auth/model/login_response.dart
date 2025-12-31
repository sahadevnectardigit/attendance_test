class LoginResponse {
  final int status;
  final String message;
  final String accessToken;
  final String refreshToken;
  final String redirectUrl;
  final String schemaName;
  final String companyCode;
  final bool enableNepaliDate;

  LoginResponse({
    required this.status,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.redirectUrl,
    required this.schemaName,
    required this.companyCode,
    required this.enableNepaliDate,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: _parseInt(json['status']),
      message: _parseString(json['message']),
      accessToken: _parseString(json['access_token']),
      refreshToken: _parseString(json['refresh_token']),
      redirectUrl: _parseString(json['redirect_url']),
      schemaName: _parseString(json['schema_name']),
      companyCode: _parseString(json['company_code']),
      enableNepaliDate: _parseBool(json['enable_nepali_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'redirect_url': redirectUrl,
      'schema_name': schemaName,
      'company_code': companyCode,
      'enable_nepali_date': enableNepaliDate,
    };
  }

  // Helper methods for safe parsing
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value == 1;
    return false;
  }

  LoginResponse copyWith({
    int? status,
    String? message,
    String? accessToken,
    String? refreshToken,
    String? redirectUrl,
    String? schemaName,
    String? companyCode,
    bool? enableNepaliDate,
  }) {
    return LoginResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      schemaName: schemaName ?? this.schemaName,
      companyCode: companyCode ?? this.companyCode,
      enableNepaliDate: enableNepaliDate ?? this.enableNepaliDate,
    );
  }

  @override
  String toString() {
    return 'LoginResponse(\n'
        '  status: $status,\n'
        '  message: $message,\n'
        '  accessToken: ${accessToken.substring(0, 20)}...,\n'
        '  refreshToken: ${refreshToken.substring(0, 20)}...,\n'
        '  redirectUrl: $redirectUrl,\n'
        '  schemaName: $schemaName,\n'
        '  companyCode: $companyCode,\n'
        '  enableNepaliDate: $enableNepaliDate\n'
        ')';
  }
}

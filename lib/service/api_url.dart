class ApiUrl {
  static const String baseUrl = "https://bondi-dev.nasimmondal.dev/api/v1";
  static const String register = "$baseUrl/auth/register";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";
  static const String login = "$baseUrl/auth/login";
  static const String logout = "$baseUrl/auth/logout";
  static const String refreshToken = "$baseUrl/auth/refresh-token";
  static const String forgotPassword = "$baseUrl/auth/forgot-password";
  static const String resetPassword = "$baseUrl/auth/reset-password";
  static const String resendOtp = "$baseUrl/auth/resend-otp";
}

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
  static const String listing = "$baseUrl/listing";
  static const String profile = "$baseUrl/profile/me";
  static const String updateProfile = "$baseUrl/profile/update";
  static const String publicProfile = "$baseUrl/profile/user";
  static const String sellerListings = "$baseUrl/listing/seller";
  static const String myListings = "$baseUrl/listing/me";
  static const String social = "$baseUrl/social";
  static const String sendMessage = "$baseUrl/message/send";
  static const String conversation = "$baseUrl/conversation";
  static const String conversations = "$baseUrl/conversations";
  static const String message = "$baseUrl/message";
  static const String messageSeen = "$baseUrl/message/seen";
  static const String discoveryHome = "$baseUrl/discovery/home";
  static const String discoveryFeed = "$baseUrl/discovery/feed";
  static const String discoveryCategories = "$baseUrl/discovery/categories";
  static const String discoveryCategory = "$baseUrl/discovery/category";
}

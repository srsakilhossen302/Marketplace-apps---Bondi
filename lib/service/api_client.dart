import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../helper/shared_prefe/shared_prefe.dart';
import 'api_url.dart';
import '../View/Screen/Login/view/login_screen.dart';

class ApiClient {
  static final http.Client _client = http.Client();

  // Helper to get headers with Authorization token if available
  static Future<Map<String, String>> _getHeaders({bool requireAuth = true}) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (requireAuth) {
      final token = await SharedPrefsHelper.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // GET Request
  static Future<http.Response> get(String url, {bool requireAuth = true}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    var response = await _client.get(Uri.parse(url), headers: headers);
    
    if (response.statusCode == 401 && requireAuth) {
      final success = await refreshAccessToken();
      if (success) {
        // Retry with new token
        final newHeaders = await _getHeaders(requireAuth: requireAuth);
        response = await _client.get(Uri.parse(url), headers: newHeaders);
      }
    }
    return response;
  }

  // POST Request
  static Future<http.Response> post(String url, dynamic body, {bool requireAuth = true}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    var response = await _client.post(
      Uri.parse(url),
      headers: headers,
      body: body is String ? body : jsonEncode(body),
    );

    if (response.statusCode == 401 && requireAuth) {
      final success = await refreshAccessToken();
      if (success) {
        // Retry with new token
        final newHeaders = await _getHeaders(requireAuth: requireAuth);
        response = await _client.post(
          Uri.parse(url),
          headers: newHeaders,
          body: body is String ? body : jsonEncode(body),
        );
      }
    }
    return response;
  }

  // PUT Request
  static Future<http.Response> put(String url, dynamic body, {bool requireAuth = true}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    var response = await _client.put(
      Uri.parse(url),
      headers: headers,
      body: body is String ? body : jsonEncode(body),
    );

    if (response.statusCode == 401 && requireAuth) {
      final success = await refreshAccessToken();
      if (success) {
        // Retry with new token
        final newHeaders = await _getHeaders(requireAuth: requireAuth);
        response = await _client.put(
          Uri.parse(url),
          headers: newHeaders,
          body: body is String ? body : jsonEncode(body),
        );
      }
    }
    return response;
  }

  // DELETE Request
  static Future<http.Response> delete(String url, {bool requireAuth = true}) async {
    final headers = await _getHeaders(requireAuth: requireAuth);
    var response = await _client.delete(Uri.parse(url), headers: headers);

    if (response.statusCode == 401 && requireAuth) {
      final success = await refreshAccessToken();
      if (success) {
        // Retry with new token
        final newHeaders = await _getHeaders(requireAuth: requireAuth);
        response = await _client.delete(Uri.parse(url), headers: newHeaders);
      }
    }
    return response;
  }

  // Refresh Token Logic
  static Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await SharedPrefsHelper.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _handleSessionExpired();
        return false;
      }

      final response = await _client.post(
        Uri.parse(ApiUrl.refreshToken),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final data = responseBody['data'];
        final newAccessToken = data != null ? data['accessToken'] : null;
        final newRefreshToken = data != null ? data['refreshToken'] : null;

        if (newAccessToken != null) {
          await SharedPrefsHelper.saveToken(newAccessToken);
        }
        if (newRefreshToken != null) {
          await SharedPrefsHelper.saveRefreshToken(newRefreshToken);
        }
        return true;
      } else {
        _handleSessionExpired();
        return false;
      }
    } catch (e) {
      _handleSessionExpired();
      return false;
    }
  }

  static void _handleSessionExpired() async {
    await SharedPrefsHelper.clearAll();
    Get.offAll(() => const LoginScreen());
    Get.snackbar(
      'Session Expired',
      'Please login again to continue.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}

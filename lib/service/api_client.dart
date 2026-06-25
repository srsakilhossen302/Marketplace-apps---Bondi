import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../helper/shared_prefe/shared_prefe.dart';
import 'api_url.dart';
import '../View/Screen/Login/view/login_screen.dart';

class ApiClient {
  static final http.Client _client = http.Client();

  // Helper to log requests
  static void _logRequest(String method, String url, {Map<String, String>? headers, dynamic body}) {
    print('--> HTTP $method $url');
    if (headers != null) {
      print('Headers: $headers');
    }
    if (body != null) {
      print('Payload: $body');
    }
  }

  // Helper to log responses
  static void _logResponse(String method, String url, http.Response response) {
    print('<-- HTTP ${response.statusCode} $method $url');
    print('Response Body: ${response.body}');
  }

  // Helper to log exceptions
  static void _logError(String method, String url, Object error, StackTrace? stack) {
    print('xxx HTTP $method $url Error: $error');
    if (stack != null) {
      print('Stack Trace: $stack');
    }
  }

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

  // Multipart POST Request (for file uploads)
  static Future<http.StreamedResponse> multipartPost(
    String url,
    Map<String, String> fields, {
    List<http.MultipartFile> files = const [],
    bool requireAuth = true,
  }) async {
    final method = 'MULTIPART-POST';
    _logRequest(method, url, body: fields);
    print('Files to upload: ${files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').toList()}');
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      
      // Add headers
      if (requireAuth) {
        final token = await SharedPrefsHelper.getToken();
        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }
      
      // Add fields
      request.fields.addAll(fields);
      
      // Add files
      for (var file in files) {
        request.files.add(file);
      }
      
      final response = await request.send();
      print('<-- HTTP ${response.statusCode} $method $url');
      return response;
    } catch (e, stack) {
      _logError(method, url, e, stack);
      rethrow;
    }
  }

  // Multipart PATCH Request (for file updates)
  static Future<http.StreamedResponse> multipartPatch(
    String url,
    Map<String, String> fields, {
    List<http.MultipartFile> files = const [],
    bool requireAuth = true,
  }) async {
    final method = 'MULTIPART-PATCH';
    _logRequest(method, url, body: fields);
    print('Files to upload: ${files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').toList()}');
    try {
      final request = http.MultipartRequest('PATCH', Uri.parse(url));
      
      // Add headers
      if (requireAuth) {
        final token = await SharedPrefsHelper.getToken();
        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }
      
      // Add fields
      request.fields.addAll(fields);
      
      // Add files
      for (var file in files) {
        request.files.add(file);
      }
      
      final response = await request.send();
      print('<-- HTTP ${response.statusCode} $method $url');
      return response;
    } catch (e, stack) {
      _logError(method, url, e, stack);
      rethrow;
    }
  }

  // GET Request
  static Future<http.Response> get(String url, {bool requireAuth = true}) async {
    final method = 'GET';
    _logRequest(method, url);
    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      var response = await _client.get(Uri.parse(url), headers: headers);
      _logResponse(method, url, response);
      
      if (response.statusCode == 401 && requireAuth) {
        print('Unauthorized! Attempting token refresh...');
        final success = await refreshAccessToken();
        if (success) {
          // Retry with new token
          final newHeaders = await _getHeaders(requireAuth: requireAuth);
          _logRequest(method, url, headers: newHeaders, body: '(Retry after refresh)');
          response = await _client.get(Uri.parse(url), headers: newHeaders);
          _logResponse(method, url, response);
        }
      }
      return response;
    } catch (e, stack) {
      _logError(method, url, e, stack);
      rethrow;
    }
  }

  // POST Request
  static Future<http.Response> post(String url, dynamic body, {bool requireAuth = true}) async {
    final method = 'POST';
    _logRequest(method, url, body: body);
    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      var response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: body is String ? body : jsonEncode(body),
      );
      _logResponse(method, url, response);

      if (response.statusCode == 401 && requireAuth) {
        print('Unauthorized! Attempting token refresh...');
        final success = await refreshAccessToken();
        if (success) {
          // Retry with new token
          final newHeaders = await _getHeaders(requireAuth: requireAuth);
          _logRequest(method, url, headers: newHeaders, body: body);
          response = await _client.post(
            Uri.parse(url),
            headers: newHeaders,
            body: body is String ? body : jsonEncode(body),
          );
          _logResponse(method, url, response);
        }
      }
      return response;
    } catch (e, stack) {
      _logError(method, url, e, stack);
      rethrow;
    }
  }

  // PUT Request
  static Future<http.Response> put(String url, dynamic body, {bool requireAuth = true}) async {
    final method = 'PUT';
    _logRequest(method, url, body: body);
    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      var response = await _client.put(
        Uri.parse(url),
        headers: headers,
        body: body is String ? body : jsonEncode(body),
      );
      _logResponse(method, url, response);

      if (response.statusCode == 401 && requireAuth) {
        print('Unauthorized! Attempting token refresh...');
        final success = await refreshAccessToken();
        if (success) {
          // Retry with new token
          final newHeaders = await _getHeaders(requireAuth: requireAuth);
          _logRequest(method, url, headers: newHeaders, body: body);
          response = await _client.put(
            Uri.parse(url),
            headers: newHeaders,
            body: body is String ? body : jsonEncode(body),
          );
          _logResponse(method, url, response);
        }
      }
      return response;
    } catch (e, stack) {
      _logError(method, url, e, stack);
      rethrow;
    }
  }

  // DELETE Request
  static Future<http.Response> delete(String url, {bool requireAuth = true}) async {
    final method = 'DELETE';
    _logRequest(method, url);
    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      var response = await _client.delete(Uri.parse(url), headers: headers);
      _logResponse(method, url, response);

      if (response.statusCode == 401 && requireAuth) {
        print('Unauthorized! Attempting token refresh...');
        final success = await refreshAccessToken();
        if (success) {
          // Retry with new token
          final newHeaders = await _getHeaders(requireAuth: requireAuth);
          _logRequest(method, url, headers: newHeaders, body: '(Retry after refresh)');
          response = await _client.delete(Uri.parse(url), headers: newHeaders);
          _logResponse(method, url, response);
        }
      }
      return response;
    } catch (e, stack) {
      _logError(method, url, e, stack);
      rethrow;
    }
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

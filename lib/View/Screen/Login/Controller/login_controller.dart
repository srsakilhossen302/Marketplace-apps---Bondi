import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../Main/view/main_screen.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordObscured = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    String deviceType = '';
    String platform = '';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceType = androidInfo.model;
        platform = 'android';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
        deviceType = iosInfo.model;
        platform = 'ios';
      }
    } catch (e) {
      deviceId = 'unknown_id';
      deviceType = 'unknown_device';
      platform = Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'unknown');
    }

    return {
      'deviceId': deviceId,
      'deviceType': deviceType,
      'platform': platform,
    };
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Required Fields',
        'Please enter both email and password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    isLoading.value = true;

    try {
      final deviceData = await _getDeviceInfo();

      final response = await http.post(
        Uri.parse(ApiUrl.login),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'deviceId': deviceData['deviceId'],
          'deviceType': deviceData['deviceType'],
          'platform': deviceData['platform'],
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = responseBody['data'];
        final accessToken = data != null ? data['accessToken'] : null;
        final refreshToken = data != null ? data['refreshToken'] : null;
        final user = data != null ? data['user'] : null;
        final userId = user != null ? user['_id'] : null;

        if (accessToken != null) {
          await SharedPrefsHelper.saveToken(accessToken);
        }
        if (refreshToken != null) {
          await SharedPrefsHelper.saveRefreshToken(refreshToken);
        }
        if (userId != null) {
          await SharedPrefsHelper.saveUserId(userId);
        }

        Get.snackbar(
          'Success',
          responseBody['message'] ?? 'Logged in successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );

        Get.offAll(() => const MainScreen());
      } else {
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

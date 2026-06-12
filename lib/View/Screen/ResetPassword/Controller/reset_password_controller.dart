import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../service/api_url.dart';
import '../../Login/view/login_screen.dart';

class ResetPasswordController extends GetxController {
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();

  final isPasswordObscured = true.obs;
  final isLoading = false.obs;
  String email = '';

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments ?? '';
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  Future<void> resetPassword() async {
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text;

    if (otp.length != 6) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the 6-digit verification code.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    if (newPassword.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter a new password.',
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
      final response = await http.post(
        Uri.parse(ApiUrl.resetPassword),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          responseBody['message'] ?? 'Password reset successfully! Please login with your new password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );

        // Redirect back to LoginScreen
        Get.offAll(() => const LoginScreen());
      } else {
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Failed to reset password',
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
    otpController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}

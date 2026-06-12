import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../Success/view/success_screen.dart';

class OtpVerificationController extends GetxController {
  final otpController = TextEditingController();
  final focusNode = FocusNode();

  final isLoading = false.obs;
  final timerSeconds = 30.obs;
  String email = '';

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments ?? '';
    startTimer();
  }

  void startTimer() {
    timerSeconds.value = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      timerSeconds.value--;
      return timerSeconds.value > 0;
    });
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.length != 6) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter a 6-digit code',
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
        Uri.parse(ApiUrl.verifyOtp),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Retrieve tokens
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
          responseBody['message'] ?? 'OTP Verified successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );

        Get.to(() => const SuccessScreen());
      } else {
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Verification failed',
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

  void resendCode() {
    Get.snackbar(
      'Code Resent',
      'A new verification code has been sent to your email',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
    startTimer();
  }

  @override
  void onClose() {
    otpController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}

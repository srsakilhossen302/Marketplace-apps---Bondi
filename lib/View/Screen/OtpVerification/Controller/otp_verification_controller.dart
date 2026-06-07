import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {
  final otpController = TextEditingController();
  final focusNode = FocusNode();
  
  final isLoading = false.obs;
  final timerSeconds = 30.obs;

  @override
  void onInit() {
    super.onInit();
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

  void verifyOtp(String otp) {
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

    // Simulate API request
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar(
        'Success!',
        'Your account has been verified!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    });
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

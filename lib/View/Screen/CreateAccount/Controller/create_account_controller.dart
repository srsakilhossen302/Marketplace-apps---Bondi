import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../OtpVerification/view/otp_verification_screen.dart';

class CreateAccountController extends GetxController {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordObscured = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void createAccount() {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (fullName.isEmpty || username.isEmpty || phoneNumber.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Required Fields',
        'Please fill in all fields.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar(
        'Account Created!',
        'Please verify your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      Get.to(() => const OtpVerificationScreen());
    });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    usernameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

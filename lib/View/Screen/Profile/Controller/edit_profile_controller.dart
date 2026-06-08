import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final usernameController = TextEditingController(text: 'alexrivers');
  final displayNameController = TextEditingController(text: 'Alex Rivers');
  final bioController = TextEditingController(
    text:
        'Sneaker collector and vintage tech enthusiast. Let\'s trade! Always looking for rare 90s hardware and limited releases.',
  );
  final phoneNumberController = TextEditingController(
    text: '+55 11 98765-4321',
  );
  final cpfController = TextEditingController(text: '000.000.000-00');

  final selectedColorIndex = 0.obs;
  final publicVisibility = true.obs;
  final pixKeyType = 'Phone Number'.obs;

  final themeColors = [
    const Color(0xFF0044CC),
    const Color(0xFF006699),
    const Color(0xFF334455),
    const Color(0xFF00E5FF),
  ];

  @override
  void onClose() {
    usernameController.dispose();
    displayNameController.dispose();
    bioController.dispose();
    phoneNumberController.dispose();
    cpfController.dispose();
    super.onClose();
  }

  void saveChanges() {
    Get.back();
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

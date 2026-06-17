import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import 'profile_controller.dart';
import 'user_profile_controller.dart';

class EditProfileController extends GetxController {
  final usernameController = TextEditingController();
  final displayNameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final cpfController = TextEditingController(text: '000.000.000-00');

  final publicVisibility = true.obs;
  final pixKeyType = 'Phone Number'.obs;

  // Profile image picking states
  final Rxn<XFile> selectedImage = Rxn<XFile>();
  final RxString currentImageUrl = ''.obs;
  final ImagePicker _imagePicker = ImagePicker();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.profile);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final profileData = data['data'];

        if (profileData != null) {
          displayNameController.text = profileData['displayName'] ?? '';
          usernameController.text = profileData['username'] ?? '';
          bioController.text = profileData['bio'] ?? '';
          phoneNumberController.text = profileData['phone'] ?? '';
          countryController.text = profileData['country'] ?? '';
          cityController.text = profileData['city'] ?? '';
          
          if (profileData['isPhonePublic'] != null) {
            if (profileData['isPhonePublic'] is bool) {
              publicVisibility.value = profileData['isPhonePublic'];
            } else {
              publicVisibility.value = profileData['isPhonePublic'].toString().toLowerCase() == 'true';
            }
          }

          if (profileData['profileImage'] != null &&
              profileData['profileImage'].toString().isNotEmpty) {
            currentImageUrl.value = profileData['profileImage'];
          }
        }
      }
    } catch (e) {
      print('Error fetching profile in edit: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickProfileImage() async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        selectedImage.value = picked;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    displayNameController.dispose();
    bioController.dispose();
    phoneNumberController.dispose();
    countryController.dispose();
    cityController.dispose();
    cpfController.dispose();
    super.onClose();
  }

  Future<void> saveChanges() async {
    isLoading.value = true;
    try {
      Map<String, String> fields = {
        'displayName': displayNameController.text.trim(),
        'bio': bioController.text.trim(),
        'isPhonePublic': publicVisibility.value.toString(),
        'country': countryController.text.trim(),
        'city': cityController.text.trim(),
      };

      if (phoneNumberController.text.trim().isNotEmpty) {
        fields['phone'] = phoneNumberController.text.trim();
      }

      List<http.MultipartFile> files = [];
      if (selectedImage.value != null) {
        files.add(await http.MultipartFile.fromPath(
          'profileImage',
          selectedImage.value!.path,
        ));
      }

      final response = await ApiClient.multipartPatch(
        ApiUrl.updateProfile,
        fields,
        files: files,
      );

      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchProfile();
        }
        if (Get.isRegistered<UserProfileController>()) {
          Get.find<UserProfileController>().fetchProfile();
        }

        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      } else {
        final errorData = json.decode(responseData.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

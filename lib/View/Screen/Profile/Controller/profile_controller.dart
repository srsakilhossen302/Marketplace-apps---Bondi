import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../../../service/api_client.dart';
import '../../Login/view/login_screen.dart';

class ProfileController extends GetxController {
  final userName = ''.obs;
  final displayName = ''.obs;
  final bondId = ''.obs;
  final referralCode = ''.obs;
  final creditsEarned = 'R\$ 0,00'.obs;
  final userImage = 'https://i.pravatar.cc/150?u=default'.obs;
  final bio = ''.obs;
  final country = ''.obs;
  final city = ''.obs;
  final email = ''.obs;
  final isLoading = false.obs;

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
          displayName.value = profileData['displayName'] ?? 'User';
          userName.value = profileData['username'] ?? 'user';
          email.value = profileData['email'] ?? '';
          bio.value = profileData['bio'] ?? '';
          country.value = profileData['country'] ?? '';
          city.value = profileData['city'] ?? '';
          bondId.value = (profileData['bondId'] ?? profileData['_id']?.toString().substring(0, 4) ?? '').toString();
          referralCode.value = (profileData['referralCode'] ?? '').toString();
          creditsEarned.value = (profileData['creditsEarned'] ?? 'R\$ 0,00').toString();

          if (profileData['profileImage'] != null &&
              profileData['profileImage'].toString().isNotEmpty) {
            userImage.value = profileData['profileImage'];
          }
        }
      }
    } catch (e) {
      // Handle error silently
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      final token = await SharedPrefsHelper.getToken();
      if (token != null && token.isNotEmpty) {
        await ApiClient.post(ApiUrl.logout, {}, requireAuth: true);
      }
    } catch (e) {
      print('Error during network sign out: $e');
    } finally {
      // Reset reactive variables to clear state from memory
      userName.value = '';
      displayName.value = '';
      bondId.value = '';
      referralCode.value = '';
      creditsEarned.value = 'R\$ 0,00';
      userImage.value = 'https://i.pravatar.cc/150?u=default';
      bio.value = '';
      country.value = '';
      city.value = '';
      email.value = '';

      // Clear all GetX controllers from memory to prevent old data leaks
      Get.deleteAll(force: true);

      // Clear all local preferences (tokens, user IDs, etc.)
      await SharedPrefsHelper.clearAll();
      
      // Reset navigation and route to Login Screen
      Get.offAll(() => const LoginScreen());
    }
  }

  void copyReferralCode() {
    Get.snackbar(
      'Success',
      'Referral code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}

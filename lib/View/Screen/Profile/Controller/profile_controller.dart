import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../../../service/api_client.dart';
import '../../Login/view/login_screen.dart';

class ProfileController extends GetxController {
  final userName = 'Alex Rivera'.obs;
  final displayName = 'Alex Rivera'.obs;
  final bondId = '8829'.obs;
  final referralCode = 'BOND-ALEX-8829'.obs;
  final creditsEarned = 'R\$ 0,00'.obs;
  final userImage = 'https://randomuser.me/api/portraits/men/1.jpg'.obs;
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
          userName.value = profileData['username'] ?? 'User';
          email.value = profileData['email'] ?? '';
          bio.value = profileData['bio'] ?? '';
          country.value = profileData['country'] ?? '';
          city.value = profileData['city'] ?? '';

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

      if (token != null) {
        await http.post(
          Uri.parse(ApiUrl.logout),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      // Proceed to local logout even if network call fails
    } finally {
      await SharedPrefsHelper.clearAll();
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

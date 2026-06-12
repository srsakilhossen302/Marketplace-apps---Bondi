import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';
import '../../Login/view/login_screen.dart';

class ProfileController extends GetxController {
  final userName = 'Alex Rivera'.obs;
  final bondId = '8829'.obs;
  final referralCode = 'BOND-ALEX-8829'.obs;
  final creditsEarned = 'R\$ 0,00'.obs;
  final userImage = 'https://randomuser.me/api/portraits/men/1.jpg'.obs;

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

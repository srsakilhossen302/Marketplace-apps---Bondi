import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userName = 'Alex Rivera'.obs;
  final bondId = '8829'.obs;
  final referralCode = 'BOND-ALEX-8829'.obs;
  final creditsEarned = 'R\$ 0,00'.obs;
  final userImage = 'https://randomuser.me/api/portraits/men/1.jpg'.obs;

  void signOut() {
    // Implement sign out logic
    Get.offAllNamed('/login');
  }

  void copyReferralCode() {
    // Implement copy logic
    Get.snackbar('Success', 'Referral code copied to clipboard',
        snackPosition: SnackPosition.BOTTOM);
  }
}

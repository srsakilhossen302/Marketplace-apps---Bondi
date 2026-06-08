import 'package:get/get.dart';
import '../../Login/view/login_screen.dart';

class SuccessController extends GetxController {
  final progressValue = 0.0.obs;
  final redirectingIn = 1.obs;

  @override
  void onInit() {
    super.onInit();
    startRedirectionTimer();
  }

  void startRedirectionTimer() {
    // 1 second redirection timer
    const duration = Duration(milliseconds: 100);
    int steps = 10;
    int currentStep = 0;

    Future.doWhile(() async {
      await Future.delayed(duration);
      currentStep++;
      progressValue.value = currentStep / steps;

      if (currentStep >= steps) {
        navigateToLogin();
        return false;
      }
      return true;
    });
  }

  void navigateToLogin() {
    Get.offAll(() => const LoginScreen());
  }
}

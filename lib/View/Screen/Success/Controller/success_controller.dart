import 'package:get/get.dart';
import '../../ConnectDiscover/view/connect_discover_screen.dart';

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
        navigateToNext();
        return false;
      }
      return true;
    });
  }

  void navigateToNext() {
    Get.offAll(() => const ConnectDiscoverScreen());
  }
}

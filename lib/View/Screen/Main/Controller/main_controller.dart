import 'package:get/get.dart';
import '../../Sell/Controller/sell_controller.dart';

class MainController extends GetxController {
  final selectedIndex = 0.obs;

  void changeIndex(int index) {
    if (selectedIndex.value == 2 && index != 2) {
      // Leaving the Sell tab
      if (Get.isRegistered<SellController>()) {
        final sellController = Get.find<SellController>();
        if (!sellController.isDraftSaved) {
          sellController.clearFields();
        } else {
          sellController.isDraftSaved = false;
        }
      }
    }
    selectedIndex.value = index;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../Success/view/success_screen.dart';

class TradeController extends GetxController {
  final ListingModel product = Get.arguments;

  final cashController = TextEditingController();
  final messageController = TextEditingController();

  final selectedProduct = Rxn<ListingModel>();

  @override
  void onClose() {
    cashController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void selectProduct(ListingModel item) {
    selectedProduct.value = item;
  }

  void sendOffer() {
    // Navigate to SuccessScreen
    Get.to(() => const SuccessScreen());
  }
}

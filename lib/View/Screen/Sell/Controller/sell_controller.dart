import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final selectedCategory = 'Electronics'.obs;
  final selectedCondition = 'New'.obs;

  final allowTradeOffers = true.obs;
  final shippingAvailable = false.obs;

  final categories = ['Electronics', 'Fashion', 'Home', 'Toys', 'Others'];
  final conditions = ['New', 'Used - Like New', 'Used - Good'];

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }

  void updateCategory(String? value) {
    if (value != null) selectedCategory.value = value;
  }

  void updateCondition(String value) {
    selectedCondition.value = value;
  }
}

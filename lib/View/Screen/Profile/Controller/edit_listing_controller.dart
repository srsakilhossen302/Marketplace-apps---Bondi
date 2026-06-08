import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditListingController extends GetxController {
  final titleController = TextEditingController(text: 'Nike Air Max 270 - Infrared / Black');
  final priceController = TextEditingController(text: '150');
  final descriptionController = TextEditingController(text: 'Authentic Nike Air Max 270 in the classic Infrared colorway. Worn only a few times, excellent condition (9/10). Comes with the original box. Looking for a cash sale or a potential trade for Jordan 1s in size 10.5. No lowball offers.');

  final category = 'Footwear'.obs;
  final status = 'Available'.obs;

  final images = [
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?q=80&w=500&auto=format&fit=crop',
  ].obs;

  final tradePreferences = [
    {'title': 'Jordan 1 Retro High', 'subtitle': 'Size 10.5 | Any Colorway'},
    {'title': 'Apple Watch Series 8', 'subtitle': '45mm | Midnight'},
  ].obs;

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void saveChanges() {
    Get.back();
    Get.snackbar('Success', 'Listing updated successfully', snackPosition: SnackPosition.BOTTOM);
  }
}

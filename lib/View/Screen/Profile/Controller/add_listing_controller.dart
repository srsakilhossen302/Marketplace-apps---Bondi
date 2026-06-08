import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddListingController extends GetxController {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final tradePrefController = TextEditingController();
  final locationController = TextEditingController();

  final category = 'Select'.obs;
  final condition = 'New'.obs;
  final openToOffers = false.obs;
  final availableForShipping = false.obs;
  final localPickup = false.obs;

  final images = [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=500&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=500&auto=format&fit=crop',
  ].obs;

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    tradePrefController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void publishListing() {
    Get.back();
    Get.snackbar('Success', 'Listing published successfully', snackPosition: SnackPosition.BOTTOM);
  }
}

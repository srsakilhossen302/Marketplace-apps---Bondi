import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectDiscoverController extends GetxController {
  final searchController = TextEditingController();

  // Mock data for UI
  final hubs = [
    {'name': 'Sneaker Traders', 'members': '2.4k Members', 'icon': Icons.shopping_basket_outlined},
    {'name': 'Gaming Hub', 'members': '1.8k Members', 'icon': Icons.videogame_asset_outlined},
  ].obs;

  final friends = [
    {'name': 'Elena Rodriguez', 'username': '@elena_design', 'image': 'https://i.pravatar.cc/150?u=elena'},
    {'name': 'Julian Vane', 'username': '@julian_v', 'image': 'https://i.pravatar.cc/150?u=julian'},
  ].obs;

  final contacts = [
    {'name': 'Alex Kim', 'phone': '+1 (555) 012-3456', 'initials': 'AK'},
    {'name': 'Maya Lin', 'phone': '+1 (555) 987-6543', 'initials': 'ML'},
  ].obs;

  void syncContacts() {
    Get.snackbar(
      'Syncing',
      'Syncing your contacts...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void continueToFeed() {
    // Navigate to feed/home
    Get.snackbar(
      'Success',
      'Navigating to feed...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

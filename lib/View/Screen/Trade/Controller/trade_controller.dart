import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../Success/view/success_screen.dart';

class TradeController extends GetxController {
  final ListingModel product = Get.arguments;

  final cashController = TextEditingController();
  final messageController = TextEditingController();

  final myProducts = <Map<String, dynamic>>[
    {
      "title": "Air Jordan 1 Retro",
      "price": "\$1,250.00",
      "image":
          "https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=500&auto=format&fit=crop",
      "details": "Chicago Colorway • Size 10.5",
    },
    {
      "title": "Bond Chronograph",
      "price": "\$4,800.00",
      "image":
          "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=500&auto=format&fit=crop",
      "details": "Silver Edition • Ref. 9920",
    },
    {
      "title": "Premium Audio-B1",
      "price": "\$550.00",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=500&auto=format&fit=crop",
      "details": "Wireless ANC • Midnight",
    },
  ].obs;

  final selectedProductIndex = (-1).obs;
  final selectedProduct = Rxn<ListingModel>();

  final categories = ["All", "Watches", "Sneakers", "Electronics"].obs;
  final selectedCategory = "All".obs;

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

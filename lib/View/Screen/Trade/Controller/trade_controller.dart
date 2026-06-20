import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../Success/view/success_screen.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/network_img/image_helper.dart';

class TradeController extends GetxController {
  final ListingModel product = Get.arguments;

  final cashController = TextEditingController();
  final messageController = TextEditingController();

  final myProducts = <Map<String, dynamic>>[].obs;
  final isLoadingListings = false.obs;

  final selectedProductIndex = (-1).obs;
  final selectedProduct = Rxn<ListingModel>();

  final categories = ["All", "Watches", "Sneakers", "Electronics"].obs;
  final selectedCategory = "All".obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyListings();
  }

  @override
  void onClose() {
    cashController.dispose();
    messageController.dispose();
    super.onClose();
  }

  Future<void> fetchMyListings() async {
    isLoadingListings.value = true;
    try {
      final response = await ApiClient.get(ApiUrl.myListings, requireAuth: true);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> list = decoded['data'];
          final List<Map<String, dynamic>> loadedListings = [];
          for (var item in list) {
            String thumbnail = item['thumbnail']?.toString().replaceAll('`', '').trim() ?? '';
            if (thumbnail.isEmpty && item['images'] != null && (item['images'] as List).isNotEmpty) {
              thumbnail = item['images'][0].toString().replaceAll('`', '').trim();
            }
            if (thumbnail.isEmpty) {
              thumbnail = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop';
            }
            loadedListings.add({
              "id": (item['_id'] ?? '').toString(),
              "title": (item['title'] ?? 'No Title').toString(),
              "price": "\$${item['price']?.toString() ?? '0'}",
              "image": ImageHelper.formatImageUrl(thumbnail),
              "details": (item['description'] ?? '').toString(),
              "category": (item['category'] ?? '').toString(),
              "slug": (item['slug'] ?? '').toString(),
            });
          }
          myProducts.assignAll(loadedListings);
        }
      }
    } catch (e) {
      print('Error fetching my listings: $e');
    } finally {
      isLoadingListings.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredProducts {
    final cat = selectedCategory.value;
    if (cat == "All") {
      return myProducts;
    }
    return myProducts.where((product) {
      final category = (product['category'] ?? '').toString().toLowerCase();
      return category == cat.toLowerCase();
    }).toList();
  }

  void selectProduct(ListingModel item) {
    selectedProduct.value = item;
  }

  void sendOffer() {
    Get.to(() => const SuccessScreen());
  }
}

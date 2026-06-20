import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Model/home_models.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../service/api_client.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/network_img/image_helper.dart';
import '../../Messages/view/chat_detail_screen.dart';

class TradeController extends GetxController {
  late final ListingModel product;
  String receiverId = '';
  String receiverListingId = '';

  final cashController = TextEditingController();
  final messageController = TextEditingController();

  final myProducts = <Map<String, dynamic>>[].obs;
  final isLoadingListings = false.obs;

  final selectedProductIndex = (-1).obs;
  final selectedProduct = Rxn<ListingModel>();
  final requesterListingId = ''.obs;

  final categories = ["All", "Watches", "Sneakers", "Electronics"].obs;
  final selectedCategory = "All".obs;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is Map) {
      product = args['product'] as ListingModel;
      receiverId = args['receiverId']?.toString() ?? '';
      receiverListingId = args['receiverListingId']?.toString() ?? '';
    } else if (args is ListingModel) {
      product = args;
    } else {
      product = ListingModel(title: '', price: '', seller: '', image: '');
    }

    super.onInit();

    if ((receiverListingId.isEmpty || receiverId.isEmpty) && product.slug.isNotEmpty) {
      fetchReceiverDetails(product.slug);
    }
    fetchMyListings();
  }

  @override
  void onClose() {
    cashController.dispose();
    messageController.dispose();
    super.onClose();
  }

  Future<void> fetchReceiverDetails(String slug) async {
    try {
      final response = await ApiClient.get(
        '${ApiUrl.listing}/$slug',
        requireAuth: true,
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final listing = decoded['data']['listing'] ?? {};
          if (receiverListingId.isEmpty) {
            receiverListingId = listing['_id']?.toString() ?? '';
          }
          if (receiverId.isEmpty) {
            receiverId = listing['sellerId']?.toString() ?? '';
          }
        }
      }
    } catch (e) {
      print('Error fetching receiver details: $e');
    }
  }

  Future<void> fetchMyListings() async {
    isLoadingListings.value = true;
    try {
      final response = await ApiClient.get('${ApiUrl.myListings}?statusTab=active', requireAuth: true);
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

  void selectMyProduct(int index, Map<String, dynamic> productMap) {
    selectedProductIndex.value = index;
    selectedProduct.value = ListingModel(
      title: productMap['title'] ?? '',
      price: productMap['price'] ?? '',
      image: productMap['image'] ?? '',
      seller: "Me",
      slug: productMap['slug'] ?? '',
    );
    requesterListingId.value = productMap['id']?.toString() ?? '';
  }

  void selectProduct(ListingModel item) {
    selectedProduct.value = item;
  }

  Future<void> sendOffer() async {
    if (selectedProduct.value == null || requesterListingId.value.isEmpty) {
      Get.snackbar(
        'Warning',
        'Please select a product to trade.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    final cashText = cashController.text.trim();
    num offeredCashAmount = 0;
    if (cashText.isNotEmpty) {
      offeredCashAmount = num.tryParse(cashText) ?? 0;
    }

    final tradeType = offeredCashAmount > 0 ? "trade_plus_cash" : "trade";
    final message = messageController.text.trim();

    final Map<String, dynamic> payload = {
      "receiverId": receiverId,
      "receiverListingId": receiverListingId,
      "requesterListingId": requesterListingId.value,
      "tradeType": tradeType,
    };

    if (tradeType == "trade_plus_cash") {
      payload["offeredCashAmount"] = offeredCashAmount;
    }

    if (message.isNotEmpty) {
      payload["message"] = message;
    }

    isLoadingListings.value = true;
    try {
      final response = await ApiClient.post(
        ApiUrl.tradeOffer,
        payload,
        requireAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          Get.dialog(
            Dialog(
              backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Container(
                padding: EdgeInsets.all(25.r),
                decoration: BoxDecoration(
                  color: AppColors.cardColor.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: const BoxDecoration(
                        color: AppColors.accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Offer Sent!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Your trade offer has been sent successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          // Close dialog and the trade offer screen
                          Get.close(2);
                          // Route to the Chat Detail Screen with the seller
                          Get.to(
                            () => const ChatDetailScreen(),
                            arguments: {
                              'userId': receiverId,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        child: Text(
                          'Go to Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          );
        } else {
          Get.snackbar(
            'Error',
            decoded['message'] ?? 'Failed to send trade offer',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.9),
            colorText: Colors.white,
          );
        }
      } else {
        final decoded = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          decoded['message'] ?? 'Failed to send trade offer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoadingListings.value = false;
    }
  }
}

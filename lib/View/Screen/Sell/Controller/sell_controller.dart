import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../../../service/api_url.dart';
import '../../../../service/api_client.dart';
import '../../Main/Controller/main_controller.dart';

class SellController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();

  final selectedCategory = 'Electronics'.obs;
  final selectedCondition = 'New'.obs;
  final selectedTransactionType = 'Trade or Sell'.obs;

  final allowTradeOffers = true.obs;
  final shippingAvailable = false.obs;
  final availableForPickup = true.obs;

  final categories = ['Electronics', 'Fashion', 'Home', 'Toys', 'Others'];
  final conditions = ['New', 'Used - Like New', 'Used - Good'];
  final transactionTypes = ['Trade', 'Sell', 'Trade or Sell'];

  final RxList<XFile> selectedImages = <XFile>[].obs;
  final RxList<XFile> selectedVideos = <XFile>[].obs;

  final ImagePicker _imagePicker = ImagePicker();
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.onClose();
  }

  void updateCategory(String? value) {
    if (value != null) selectedCategory.value = value;
  }

  void updateCondition(String value) {
    selectedCondition.value = value;
  }

  void updateTransactionType(String value) {
    selectedTransactionType.value = value;
  }

  Future<bool> _requestStoragePermission() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      status = await Permission.storage.request();
    } else if (Platform.isIOS) {
      status = await Permission.photosAddOnly.request();
    } else {
      return true;
    }

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      Get.snackbar(
        'Permission Required',
        'Please enable storage permission in settings',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text(
            'Open Settings',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return false;
    } else {
      Get.snackbar(
        'Permission Denied',
        'Storage permission is required to select media',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<void> pickImages() async {
    bool hasPermission = await _requestStoragePermission();
    if (!hasPermission) return;

    try {
      final List<XFile>? images = await _imagePicker.pickMultiImage(
        imageQuality: 80,
        limit: 10,
      );
      if (images != null) {
        for (var img in images) {
          if (selectedImages.length < 10) {
            selectedImages.add(img);
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select images: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickVideos() async {
    bool hasPermission = await _requestStoragePermission();
    if (!hasPermission) return;

    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60),
      );
      if (video != null && selectedVideos.length < 1) {
        selectedVideos.add(video);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select video: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  void removeVideo(int index) {
    selectedVideos.removeAt(index);
  }

  String getListingType() {
    final type = selectedTransactionType.value;
    if (type == 'Trade') return 'trade';
    if (type == 'Sell') return 'sale';
    return 'sale_and_trade';
  }

  String getCondition() {
    final condition = selectedCondition.value;
    if (condition == 'New') return 'new';
    if (condition == 'Used - Like New') return 'like_new';
    if (condition == 'Used - Good') return 'good';
    return 'good';
  }

  Future<void> submitListing({bool isDraft = false}) async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedCategory.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields');
      return;
    }

    isLoading.value = true;
    try {
      Map<String, String> fields = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory.value,
        'listingType': getListingType(),
        'condition': getCondition(),
        'status': isDraft ? 'draft' : 'active',
        'country': countryController.text.trim().isNotEmpty
            ? countryController.text.trim()
            : 'USA',
        'city': cityController.text.trim().isNotEmpty
            ? cityController.text.trim()
            : 'New York',
        'price': priceController.text.trim().isNotEmpty
            ? priceController.text.trim()
            : '',
        'isOpenToAllTrades': allowTradeOffers.value.toString(),
        'isAvailableForShipping': shippingAvailable.value.toString(),
        'isAvailableForPickup': availableForPickup.value.toString(),
      };

      List<http.MultipartFile> files = [];

      // Add images
      for (var image in selectedImages) {
        files.add(await http.MultipartFile.fromPath('images', image.path));
      }

      // Add videos
      for (var video in selectedVideos) {
        files.add(await http.MultipartFile.fromPath('videos', video.path));
      }

      // Add thumbnail (first image if exists)
      if (selectedImages.isNotEmpty) {
        files.add(
          await http.MultipartFile.fromPath(
            'thumbnail',
            selectedImages.first.path,
          ),
        );
      }

      final response = await ApiClient.multipartPost(
        ApiUrl.listing,
        fields,
        files: files,
      );

      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Go to home screen
        final mainController = Get.find<MainController>();
        mainController.changeIndex(0);
        Get.back();
        Get.snackbar(
          'Success',
          isDraft
              ? 'Listing saved as draft!'
              : 'Listing published successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        final errorData = json.decode(responseData.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to create listing',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

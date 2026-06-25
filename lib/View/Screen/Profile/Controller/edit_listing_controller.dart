import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../service/api_url.dart';
import '../../../../service/api_client.dart';
import 'user_profile_controller.dart';
import '../view/subscription_screen.dart';

class EditListingController extends GetxController {
  late final String listingId;
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();

  final category = 'Electronics'.obs;
  final status = 'Available'.obs;

  final categories = ['Electronics', 'Fashion', 'Home', 'Toys', 'Others'].obs;
  final images = <dynamic>[].obs; // Unified list of String (network URLs) and XFile (local)

  final ImagePicker _imagePicker = ImagePicker();
  final RxBool isLoading = false.obs;

  // Preserved Listing properties (not editable but required by API)
  String listingType = 'sale_and_trade';
  String condition = 'new';
  bool isOpenToAllTrades = true;
  bool isAvailableForShipping = false;
  bool isAvailableForPickup = true;

  final tradePreferences = [
    {'title': 'Jordan 1 Retro High', 'subtitle': 'Size 10.5 | Any Colorway'},
    {'title': 'Apple Watch Series 8', 'subtitle': '45mm | Midnight'},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final dynamic listing = Get.arguments;
    if (listing != null && listing is Map) {
      listingId = (listing['_id'] ?? listing['id'] ?? '').toString();
      titleController.text = (listing['title'] ?? '').toString();
      priceController.text = (listing['price'] ?? '').toString();
      descriptionController.text = (listing['description'] ?? '').toString();
      countryController.text = (listing['country'] ?? 'USA').toString();
      cityController.text = (listing['city'] ?? 'New York').toString();

      // Category
      setCategory((listing['category'] ?? 'Electronics').toString());

      // Status mapping: 'active' -> 'Available', 'pending' -> 'Pending Trade', 'sold' -> 'Sold'
      final apiStatus = (listing['status'] ?? 'active').toString().toLowerCase();
      if (apiStatus == 'pending') {
        status.value = 'Pending Trade';
      } else if (apiStatus == 'sold') {
        status.value = 'Sold';
      } else {
        status.value = 'Available';
      }

      // Preserved values
      listingType = (listing['listingType'] ?? 'sale_and_trade').toString();
      condition = (listing['condition'] ?? 'new').toString();
      isOpenToAllTrades = listing['isOpenToAllTrades'] == true || listing['isOpenToAllTrades']?.toString().toLowerCase() == 'true';
      isAvailableForShipping = listing['isAvailableForShipping'] == true || listing['isAvailableForShipping']?.toString().toLowerCase() == 'true';
      isAvailableForPickup = listing['isAvailableForPickup'] == true || listing['isAvailableForPickup']?.toString().toLowerCase() == 'true';

      // Images
      images.clear();
      if (listing['images'] != null && listing['images'] is List) {
        for (var img in listing['images']) {
          final cleaned = img.toString().replaceAll('`', '').trim();
          if (cleaned.isNotEmpty) {
            images.add(cleaned);
          }
        }
      } else if (listing['thumbnail'] != null) {
        final cleaned = listing['thumbnail'].toString().replaceAll('`', '').trim();
        if (cleaned.isNotEmpty) {
          images.add(cleaned);
        }
      }
    } else {
      listingId = '';
    }
  }

  void setCategory(String val) {
    String matched = categories.firstWhere(
      (c) => c.toLowerCase() == val.toLowerCase(),
      orElse: () {
        categories.add(val);
        return val;
      },
    );
    category.value = matched;
  }

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.onClose();
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
          child: const Text('Open Settings', style: TextStyle(color: Colors.white)),
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
    if (images.length >= 10) {
      Get.snackbar('Limit Reached', 'You can upload up to 10 photos only');
      return;
    }

    bool hasPermission = await _requestStoragePermission();
    if (!hasPermission) return;

    try {
      final List<XFile>? picked = await _imagePicker.pickMultiImage(
        imageQuality: 80,
        limit: 10 - images.length,
      );
      if (picked != null) {
        for (var img in picked) {
          if (images.length < 10) {
            images.add(img);
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

  void removeImage(int index) {
    images.removeAt(index);
  }

  Future<void> saveChanges() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        category.value.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields');
      return;
    }

    isLoading.value = true;
    try {
      String statusStr = 'active';
      if (status.value == 'Pending Trade') {
        statusStr = 'pending';
      } else if (status.value == 'Sold') {
        statusStr = 'sold';
      }

      Map<String, String> fields = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': category.value,
        'listingType': listingType,
        'condition': condition,
        'status': statusStr,
        'country': countryController.text.trim().isNotEmpty
            ? countryController.text.trim()
            : 'USA',
        'city': cityController.text.trim().isNotEmpty
            ? cityController.text.trim()
            : 'New York',
        'price': priceController.text.trim().isNotEmpty
            ? priceController.text.trim()
            : '',
        'isOpenToAllTrades': isOpenToAllTrades.toString(),
        'isAvailableForShipping': isAvailableForShipping.toString(),
        'isAvailableForPickup': isAvailableForPickup.toString(),
      };

      List<http.MultipartFile> files = [];

      for (var img in images) {
        if (img is String) {
          try {
            final response = await http.get(Uri.parse(img));
            if (response.statusCode == 200) {
              final uri = Uri.parse(img);
              String fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'image.jpg';
              files.add(http.MultipartFile.fromBytes(
                'images',
                response.bodyBytes,
                filename: fileName,
              ));
            }
          } catch (e) {
            print('Error downloading image $img: $e');
          }
        } else if (img is XFile) {
          files.add(await http.MultipartFile.fromPath('images', img.path));
        }
      }

      if (images.isNotEmpty) {
        final firstImg = images.first;
        if (firstImg is String) {
          try {
            final response = await http.get(Uri.parse(firstImg));
            if (response.statusCode == 200) {
              final uri = Uri.parse(firstImg);
              String fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'thumbnail.jpg';
              files.add(http.MultipartFile.fromBytes(
                'thumbnail',
                response.bodyBytes,
                filename: fileName,
              ));
            }
          } catch (e) {
            print('Error downloading thumbnail: $e');
          }
        } else if (firstImg is XFile) {
          files.add(await http.MultipartFile.fromPath('thumbnail', firstImg.path));
        }
      }

      final response = await ApiClient.multipartPatch(
        '${ApiUrl.listing}/$listingId',
        fields,
        files: files,
      );

      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isRegistered<UserProfileController>()) {
          Get.find<UserProfileController>().fetchMyListings();
        }
        Get.back();
        Get.snackbar(
          'Success',
          'Listing updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        final errorData = json.decode(responseData.body);
        final errorMessage = errorData['message'] ?? 'Failed to update listing';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
        if (errorMessage.toLowerCase().contains('subscription') || errorMessage.toLowerCase().contains('upgrade')) {
          Get.to(() => const SubscriptionScreen());
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void confirmDelete() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Delete Listing', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this listing? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteListing();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> deleteListing() async {
    isLoading.value = true;
    try {
      final response = await ApiClient.delete('${ApiUrl.listing}/$listingId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (Get.isRegistered<UserProfileController>()) {
          Get.find<UserProfileController>().fetchMyListings();
        }
        Get.back();
        Get.snackbar(
          'Success',
          'Listing deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete listing',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

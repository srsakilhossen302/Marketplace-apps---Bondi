import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../../../service/api_url.dart';
import '../../../../service/api_client.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../Main/Controller/main_controller.dart';
import '../../Profile/Controller/user_profile_controller.dart';

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

  final RxList<String> categories = <String>['Electronics', 'Fashion', 'Home', 'Toys', 'Books', 'Sports', 'Vehicles', 'Others'].obs;
  final conditions = ['New', 'Used - Like New', 'Used - Good'];
  final transactionTypes = ['Trade', 'Sell', 'Trade or Sell'];

  final RxList<dynamic> selectedImages = <dynamic>[].obs;
  final RxList<dynamic> selectedVideos = <dynamic>[].obs;

  final ImagePicker _imagePicker = ImagePicker();
  final RxBool isLoading = false.obs;

  final myGroups = <Map<String, dynamic>>[].obs;
  final isGroupsLoading = false.obs;
  final selectedGroupIds = <String>{}.obs;

  bool isEditMode = false;
  String listingId = '';
  bool isDraftSaved = false;

  @override
  void onInit() {
    super.onInit();
    fetchMyGroups();
    final dynamic listing = Get.arguments;
    if (listing != null && listing is Map) {
      isEditMode = true;
      listingId = (listing['_id'] ?? listing['id'] ?? '').toString();

      titleController.text = (listing['title'] ?? '').toString();
      descriptionController.text = (listing['description'] ?? '').toString();
      priceController.text = (listing['price'] ?? '').toString();
      countryController.text = (listing['country'] ?? '').toString();
      cityController.text = (listing['city'] ?? '').toString();

      // Category handling (add if custom)
      final apiCategory = (listing['category'] ?? '').toString();
      if (apiCategory.isNotEmpty) {
        final matched = categories.firstWhere(
          (c) => c.toLowerCase() == apiCategory.toLowerCase(),
          orElse: () {
            final index = categories.indexOf('Others');
            if (index != -1) {
              categories.insert(index, apiCategory);
            } else {
              categories.add(apiCategory);
            }
            return apiCategory;
          },
        );
        selectedCategory.value = matched;
      }

      // Condition mapping: 'new' -> 'New', 'like_new' -> 'Used - Like New', 'good' -> 'Used - Good'
      final apiCondition = (listing['condition'] ?? '').toString().toLowerCase();
      if (apiCondition == 'new') {
        selectedCondition.value = 'New';
      } else if (apiCondition == 'like_new') {
        selectedCondition.value = 'Used - Like New';
      } else if (apiCondition == 'good') {
        selectedCondition.value = 'Used - Good';
      }

      // Transaction type mapping: 'sale' -> 'Sell', 'trade' -> 'Trade', 'sale_and_trade' -> 'Trade or Sell'
      final apiType = (listing['listingType'] ?? '').toString().toLowerCase();
      if (apiType == 'sale') {
        selectedTransactionType.value = 'Sell';
      } else if (apiType == 'trade') {
        selectedTransactionType.value = 'Trade';
      } else {
        selectedTransactionType.value = 'Trade or Sell';
      }

      // Switches
      allowTradeOffers.value = listing['isOpenToAllTrades'] == true || listing['isOpenToAllTrades']?.toString().toLowerCase() == 'true';
      shippingAvailable.value = listing['isAvailableForShipping'] == true || listing['isAvailableForShipping']?.toString().toLowerCase() == 'true';
      availableForPickup.value = listing['isAvailableForPickup'] == true || listing['isAvailableForPickup']?.toString().toLowerCase() == 'true';

      // Images (URLs and XFiles)
      selectedImages.clear();
      if (listing['images'] != null && listing['images'] is List) {
        for (var img in listing['images']) {
          final cleaned = img.toString().replaceAll('`', '').trim();
          if (cleaned.isNotEmpty) {
            selectedImages.add(cleaned);
          }
        }
      } else if (listing['thumbnail'] != null) {
        final cleaned = listing['thumbnail'].toString().replaceAll('`', '').trim();
        if (cleaned.isNotEmpty) {
          selectedImages.add(cleaned);
        }
      }

      // Videos
      selectedVideos.clear();
      if (listing['videos'] != null && listing['videos'] is List) {
        for (var vid in listing['videos']) {
          final cleaned = vid.toString().replaceAll('`', '').trim();
          if (cleaned.isNotEmpty) {
            selectedVideos.add(cleaned);
          }
        }
      }
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    countryController.dispose();
    cityController.dispose();
    super.onClose();
  }

  Future<void> fetchMyGroups() async {
    isGroupsLoading.value = true;
    try {
      final response = await ApiClient.get(
        ApiUrl.myGroups,
        requireAuth: true,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> list = data['data'];
          myGroups.assignAll(list.map((e) => Map<String, dynamic>.from(e)).toList());
        }
      }
    } catch (e) {
      print('Error fetching my groups: $e');
    } finally {
      isGroupsLoading.value = false;
    }
  }

  void toggleGroupSelection(String groupId) {
    if (selectedGroupIds.contains(groupId)) {
      selectedGroupIds.remove(groupId);
    } else {
      selectedGroupIds.add(groupId);
    }
    selectedGroupIds.refresh();
  }

  void updateCategory(String? value) {
    if (value == null) return;
    if (value == 'Others') {
      final textController = TextEditingController();
      Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF1E3A8A),
          title: const Text('Custom Category', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: textController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter category name',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                final val = textController.text.trim();
                if (val.isNotEmpty) {
                  final index = categories.indexOf('Others');
                  if (index != -1) {
                    categories.insert(index, val);
                  } else {
                    categories.add(val);
                  }
                  selectedCategory.value = val;
                }
                Get.back();
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00D8F6)),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      selectedCategory.value = value;
    }
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
        limit: 5,
      );
      if (images != null) {
        for (var img in images) {
          if (selectedImages.length < 5) {
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

      if (selectedGroupIds.isNotEmpty) {
        fields['sharedGroupIds'] = jsonEncode(selectedGroupIds.toList());
      }

      List<http.MultipartFile> files = [];

      // Add images (enforce max limit of 5)
      int imageUploadedCount = 0;
      for (var img in selectedImages) {
        if (imageUploadedCount >= 5) break;
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
              imageUploadedCount++;
            }
          } catch (e) {
            print('Error downloading image $img: $e');
          }
        } else if (img is XFile) {
          files.add(await http.MultipartFile.fromPath('images', img.path));
          imageUploadedCount++;
        }
      }

      // Add videos (enforce max limit of 1)
      if (selectedVideos.isNotEmpty) {
        final video = selectedVideos.first;
        if (video is String) {
          try {
            final response = await http.get(Uri.parse(video));
            if (response.statusCode == 200) {
              final uri = Uri.parse(video);
              String fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'video.mp4';
              files.add(http.MultipartFile.fromBytes(
                'videos',
                response.bodyBytes,
                filename: fileName,
              ));
            }
          } catch (e) {
            print('Error downloading video $video: $e');
          }
        } else if (video is XFile) {
          files.add(await http.MultipartFile.fromPath('videos', video.path));
        }
      }

      // Add thumbnail (first image if exists)
      if (selectedImages.isNotEmpty) {
        final firstImg = selectedImages.first;
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

      final response = isEditMode
          ? await ApiClient.multipartPatch(
              '${ApiUrl.listing}/$listingId',
              fields,
              files: files,
            )
          : await ApiClient.multipartPost(
              ApiUrl.listing,
              fields,
              files: files,
            );

      final responseData = await http.Response.fromStream(response);
      print('Create Listing API Response: status=${response.statusCode}, body=${responseData.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isRegistered<UserProfileController>()) {
          Get.find<UserProfileController>().fetchMyListings();
        }
        
        final wasEditMode = isEditMode;
        
        if (isDraft) {
          isDraftSaved = true;
        } else {
          clearFields();
        }
        
        if (wasEditMode) {
          Get.back();
        } else {
          if (!isDraft) {
            final mainController = Get.find<MainController>();
            mainController.changeIndex(0);
          }
        }
        
        Get.snackbar(
          'Success',
          wasEditMode
              ? 'Listing updated successfully!'
              : isDraft
                  ? 'Listing saved as draft!'
                  : 'Listing published successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        final errorData = json.decode(responseData.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to process listing',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Submit Listing Exception: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    countryController.clear();
    cityController.clear();
    selectedImages.clear();
    selectedVideos.clear();
    selectedGroupIds.clear();
    selectedCategory.value = 'Electronics';
    selectedCondition.value = 'New';
    selectedTransactionType.value = 'Trade or Sell';
    allowTradeOffers.value = true;
    shippingAvailable.value = false;
    availableForPickup.value = true;
    isEditMode = false;
    listingId = '';
    isDraftSaved = false;
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
    if (listingId.isEmpty) {
      Get.snackbar('Error', 'Listing ID is empty', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;
    try {
      final response = await ApiClient.delete('${ApiUrl.listing}/$listingId', requireAuth: true);
      if (response.statusCode == 200 || response.statusCode == 204) {
        clearFields();

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
